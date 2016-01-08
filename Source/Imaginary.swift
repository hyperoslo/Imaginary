import UIKit
import Cache

public struct Imaginary {
  public static var preConfigure: ((imageView: UIImageView) -> Void)?
  public static var postConfigure: ((imageView: UIImageView) -> Void)?
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
