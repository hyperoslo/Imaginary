import Foundation
import Cache

/// Fetch image for you so that you don't have to think.
/// It can be fetched from storage or network.
public class ImageFetcher {
  private let downloader: ImageDownloader
  private let storage: Storage<String, Image>?

  /// Initialize ImageFetcehr
  ///
  /// - Parameters:
  ///   - downloader: Used to download images.
  ///   - storage: Used to store downloaded images. Pass nil to ignore cache
  public init(downloader: ImageDownloader, storage: Storage<String, Image>?) {
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
      if url.isFileURL {
        self.fetchFromDisk(url: url, completion: completion)
      } else {
        self.fetchFromNetwork(url: url, completion: completion)
      }
      return
    }

    // Try fetching from storage first
    storage.async.object(forKey: url.absoluteString, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case .value(let image):
        completion(.value(image))
      case .error:
        if url.isFileURL {
          self.fetchFromDisk(url: url, completion: completion)
        } else {
          self.fetchFromNetwork(url: url, completion: completion)
        }
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
        try? self.storage?.setObject(image, forKey: url.absoluteString)
        completion(.value(image))
      case .error(let error):
        completion(.error(error))
      }
    })
  }

  private func fetchFromDisk(url: URL, completion: @escaping (Result) -> Void) {
    DispatchQueue.global(qos: .utility).async {
      [weak self] in
      guard let `self` = self else {
        return
      }

      let fileManager = FileManager.default
      guard let data = fileManager.contents(atPath: url.path) else {
        completion(.error(ImaginaryError.invalidData))
        return
      }

      guard let image = Decompressor().decompress(data: data) else {
        completion(.error(ImaginaryError.conversionError))
        return
      }

      // Try saving to storage
      try? self.storage?.setObject(image, forKey: url.absoluteString)
      completion(.value(image))
    }
  }

}
