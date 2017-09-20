import Foundation
import Cache

/// Option applied when fetching image
public struct Option {

  /// Pre process downloaded image before it gets applied to UI
  public var imagePreprocessor: ImageProcessing?

  /// To apply transition or custom animation when display image
  public var imageDisplayer: ImageDisplaying = SimpleImageDisplayer()

  /// The image storage, defaults to Configuration.imageStorage.
  /// Specify nil to ignore storage.
  public var imageStorage: Storage? = Configuration.imageStorage

  public init() {}
}
