import Foundation
import Cache

/// Option applied when fetching image
public struct Option {

  /// Pre process downloaded image before it gets applied to UI
  public let imagePreprocessor: ImageProcessor?

  /// To apply transition or custom animation when display image
  public let imageDisplayer: ImageDisplayer

  /// How to make ImageFetcher to fetch.
  /// Defaults to ImageFetcher with Configuration.imageStorage, specify nil to ignore caching.
  public var fetcherMaker: () -> ImageFetcher = {
    return ImageFetcher(downloader: ImageDownloader(),
                        storage: Configuration.imageStorage)
  }

  public init(imagePreprocessor: ImageProcessor? = nil,
              imageDisplayer: ImageDisplayer = ImageViewDisplayer()) {
    self.imagePreprocessor = imagePreprocessor
    self.imageDisplayer = imageDisplayer
  }
}
