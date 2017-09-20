import Foundation
import Cache

/// Option applied when fetching image
public struct Option {

  /// Pre process downloaded image before it gets applied to UI
  public var imagePreprocessor: ImageProcessing?

  /// To apply transition or custom animation when display image
  public var imageDisplayer: ImageDisplaying = SimpleImageDisplayer()

  /// How to make ImageFetcher to fetch.
  /// Defaults to ImageFetcher with Configuration.imageStorage, specify nil to ignore caching.
  public var fetcherMaker: () -> ImageFetcher = {
    return ImageFetcher(downloader: ImageDownloader(),
                        storage: Configuration.imageStorage)
  }

  public init() {}
}
