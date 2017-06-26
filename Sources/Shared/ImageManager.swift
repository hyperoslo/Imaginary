import Foundation

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
  public func fetchImage(at url: URL?, useCache: Bool = true, completion: Completion?) {
    guard let url = url else {
      return
    }

    // If cache is disabled, it will try to fetch the image from the network.
    guard useCache else {
      self.fetchFromNetwork(url: url, useCache: useCache, completion: completion)
      return
    }

    Configuration.imageCache.async.object(forKey: url.absoluteString) { [weak self] (object: Image?) in
      guard let `self` = self else {
        return
      }

      // Return image from cache if it exists.
      if let image = object {
        DispatchQueue.main.async {
          completion?(image)
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
  fileprivate func fetchFromNetwork(url: URL, useCache: Bool = true, completion: Completion? = nil) {
    let fetcher = Fetcher(url: url)
    fetcher.start({ return $0 }) { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case let .success(image, bytes):
        Configuration.track?(url, nil, bytes)
        if useCache {
          Configuration.imageCache.async.addObject(image, forKey: url.absoluteString)
        }
        completion?(image)
        self.removeFetcher(fetcher)
      case let .failure(error):
        Configuration.track?(url, error, 0)
        completion?(nil)
        self.removeFetcher(fetcher)
      }
    }

    fetchers.append(fetcher)
  }

  /// Remove fetcher based of its index
  ///
  /// - Parameter fetcher: The `Fetcher` that should be removed from the queue.
  fileprivate func removeFetcher(_ fetcher: Fetcher) {
    guard let index = self.fetchers.index(of: fetcher) else {
      return
    }
    self.fetchers.remove(at: index)
  }
}
