import Foundation
import Cache

/// Option applied when fetching image
public struct Option {

  /// Pre process downloaded image before it gets applied to UI
  public let imagePreprocessor: ImageProcessor?

  /// To apply transition or custom animation when display image
  public let imageDisplayer: ImageDisplayer

  /// Specify Storage for memory and disk cache.
  /// Defaults to Configuration.imageStorage.
  /// Return nil to ignore cache
  public var storageMaker: () -> Storage? = {
    return Configuration.imageStorage
  }

  /// Specify ImageDownloader and request modifier
  public var downloaderMaker: () -> ImageDownloader = {
    return ImageDownloader(modifyRequest: { $0 })
  }

  public init(imagePreprocessor: ImageProcessor? = nil,
              imageDisplayer: ImageDisplayer = ImageViewDisplayer()) {
    self.imagePreprocessor = imagePreprocessor
    self.imageDisplayer = imageDisplayer
  }
}
