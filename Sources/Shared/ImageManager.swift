import Foundation
import Cache

/// `ImageManager` can be used to fetch images from a remote location. By default it will use
/// cache and return that object if it exists, if it does not exist already if will try and fetch
/// it from network. If it is successful it will store the image to the cache. You can opt-out of
/// using cache by setting `useCache` to `false` when using the `fetchImage` method.
public class ImageManager {
  /// A collection of `ImageDownloader`'s, they will be removed from the queue as soon as they are done
  /// fetching, even if the request fails to fetch.
  private var imageDownloaders = [ImageDownloader]()

  /// Public initializer
  public init() {}

  /// Fetch image from URL with completion.
  /// If the file already exists in the cache
  ///
  /// - Parameters:
  ///   - url: The URL of the image that should be fetched, either from network or cache (if cache is enabled).
  ///   - useCache: Determines if the image should be fetched from cache and stored in cached after fetching.
  ///   - completion: A completion closure that will return the image if it is successfully fetch either from cache or the network.
  public func fetchImage(from url: URL, configuration: Configuration = Configuration.default, completion: @escaping Completion) {
    // If cache is disabled, it will try to fetch the image from the network.
    guard configuration.usesCache else {
      self.fetchFromNetwork(url: url, configuration: configuration, completion: completion)
      return
    }

    configuration.imageStorage?.async.object(ofType: ImageWrapper.self,
                                            forKey: url.absoluteString) { [weak self] result in
      guard let `self` = self else {
        return
      }

      // Return image from cache if it exists.
      if case .value(let wrapper) = result {
        DispatchQueue.main.async {
          completion(wrapper.image)
        }
        return
      }

      // Fetch image from URL because it does not exist in cache.
      self.fetchFromNetwork(url: url, completion: completion)
    }
  }

  // Cancel and remove all imageDownloaders from `ImageManager`.
  public func removeImageDownloaders() {
    imageDownloaders.forEach { imageDownloader in
      imageDownloader.cancel()
      removeImageDownloader(imageDownloader)
    }
  }

  /// Fetch image from URL
  ///
  /// - Parameters:
  ///   - url: The URL of the image that should be fetch from the network.
  ///   - completion: A completion block that gets called after the network request is done.
  /// - Note: The completion will get `nil` back if the request fails to fetch the image.
  private func fetchFromNetwork(url: URL, configuration: Configuration = Configuration.default, completion: @escaping Completion) {
    let imageDownloader = ImageDownloader(url: url)
    imageDownloader.start({ return $0 }) { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case let .success(image, bytes):
        configuration.track?(url, nil, bytes)
        if configuration.usesCache {
          let wrapper = ImageWrapper(image: image)
          configuration.imageStorage?.async.setObject(wrapper, forKey: url.absoluteString, expiry: nil) { _ in
            // Don't care about result for now
          }
        }
        completion(image)
        self.removeImageDownloader(imageDownloader)
      case let .failure(error):
        configuration.track?(url, error, 0)
        completion(nil)
        self.removeImageDownloader(imageDownloader)
      }
    }

    imageDownloaders.append(imageDownloader)
  }

  /// Remove imageDownloader based of its index
  ///
  /// - Parameter imageDownloader: The `ImageDownloader` that should be removed from the queue.
  private func removeImageDownloader(_ imageDownloader: ImageDownloader) {
    guard let index = self.imageDownloaders.index(of: imageDownloader) else {
      return
    }
    self.imageDownloaders.remove(at: index)
  }
}
