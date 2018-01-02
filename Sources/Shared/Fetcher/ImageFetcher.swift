import Foundation
import Cache

/// Fetch image for you so that you don't have to think.
/// It can be fetched from storage or network.
public class ImageFetcher {
  private let downloader: ImageDownloader
  private let storage: Storage?

  /// Initialize ImageFetcehr
  ///
  /// - Parameters:
  ///   - downloader: Used to download images.
  ///   - storage: Used to store downloaded images. Pass nil to ignore cache
  public init(downloader: ImageDownloader, storage: Storage?) {
    self.downloader = downloader
    self.storage = storage
  }

  /// Cancel operations
  public func cancel() {
    downloader.cancel()
  }

  /// Fetch image from url.
  ///
  /// - Parameters:
  ///   - url: The url to fetch.
  ///   - completion: The callback upon completion.
  public func fetch(url: URL, completion: @escaping (Result) -> Void) {
    // Check if we should ignore storage
    guard let storage = storage else {
      fetchFromNetwork(url: url, completion: completion)
      return
    }

    // Try fetching from storage first
    storage.async.object(ofType: ImageWrapper.self, forKey: url.absoluteString, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case .value(let wrapper):
        completion(.value(wrapper.image))
      case .error:
        // Try to download
        self.fetchFromNetwork(url: url, completion: completion)
      }
    })
  }

  // MARK: - Helper

  private func fetchFromNetwork(url: URL, completion: @escaping (Result) -> Void) {
    downloader.download(url: url, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case .value(let image):
        // Try saving to storage
        try? self.storage?.setObject(ImageWrapper(image: image), forKey: url.absoluteString)
        completion(.value(image))
      case .error(let error):
        completion(.error(error))
      }
    })
  }
}
