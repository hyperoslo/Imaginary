import Foundation
import Cache

/// `ImageManager` can be used to fetch images from a remote location. By default it will use
/// cache and return that object if it exists, if it does not exist already if will try and fetch
/// it from network. If it is successful it will store the image to the cache. You can opt-out of
/// using cache by setting `useCache` to `false` when using the `fetchImage` method.
public class ImageManager {
  /// A collection of `Fetcher`'s, they will be removed from the queue as soon as they are done
  /// fetching, even if the request fails to fetch.
  private var fetchers = [Fetcher]()

  /// Public initializer
  public init() {}

  /// Fetch image from URL with completion.
  /// If the file already exists in the cache
  ///
  /// - Parameters:
  ///   - url: The URL of the image that should be fetched, either from network or cache (if cache is enabled).
  ///   - useCache: Determines if the image should be fetched from cache and stored in cached after fetching.
  ///   - completion: A completion closure that will return the image if it is successfully fetch either from cache or the network.
  public func fetchImage(from url: URL, useCache: Bool = true, completion: @escaping Completion) {
    // If cache is disabled, it will try to fetch the image from the network.
    guard useCache else {
      self.fetchFromNetwork(url: url, useCache: useCache, completion: completion)
      return
    }

    Configuration.imageStorage?.async.object(ofType: ImageWrapper.self,
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

  // Cancel and remove all fetchers from `ImageManager`.
  public func removeFetchers() {
    fetchers.forEach { fetcher in
      fetcher.cancel()
      removeFetcher(fetcher)
    }
  }

  /// Fetch image from URL
  ///
  /// - Parameters:
  ///   - url: The URL of the image that should be fetch from the network.
  ///   - completion: A completion block that gets called after the network request is done.
  /// - Note: The completion will get `nil` back if the request fails to fetch the image.
  private func fetchFromNetwork(url: URL, useCache: Bool = true, completion: @escaping Completion) {
    let fetcher = Fetcher(url: url)
    fetcher.start({ return $0 }) { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case let .success(image, bytes):
        Configuration.track?(url, nil, bytes)
        if useCache {
          let wrapper = ImageWrapper(image: image)
          Configuration.imageStorage?.async.setObject(wrapper, forKey: url.absoluteString, expiry: nil) { _ in
            // Don't care about result for now
          }
        }
        completion(image)
        self.removeFetcher(fetcher)
      case let .failure(error):
        Configuration.track?(url, error, 0)
        completion(nil)
        self.removeFetcher(fetcher)
      }
    }

    fetchers.append(fetcher)
  }

  /// Remove fetcher based of its index
  ///
  /// - Parameter fetcher: The `Fetcher` that should be removed from the queue.
  private func removeFetcher(_ fetcher: Fetcher) {
    guard let index = self.fetchers.index(of: fetcher) else {
      return
    }
    self.fetchers.remove(at: index)
  }
}
