import UIKit
import Cache

public struct Imaginary {

  public static var preConfigure: ((imageView: UIImageView) -> Void)? = { imageView in
    imageView.alpha = 0.0
  }

  public static var postConfigure: ((imageView: UIImageView) -> Void)? = { imageView in
    UIView.animateWithDuration(0.3) {
      imageView.alpha = 1.0
    }
  }
}

public var imageCache: Cache<UIImage> {
  struct Static {
    static let config = Config(
      frontKind: .Memory,
      backKind: .Disk,
      expiry: .Date(NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 3)),
      maxSize: 0)

    static let cache = Cache<UIImage>(name: "Imaginary")
  }

  return Static.cache
}
