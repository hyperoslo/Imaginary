import Cocoa
import Cache

public struct Imaginary {

  public static var preConfigure: ((imageView: NSImageView) -> Void)? = { imageView in
    imageView.layer?.opacity = 0.0
  }

  public static var transitionClosure: ((imageView: NSImageView, image: NSImage) -> Void) = { imageView, newImage in
    guard let oldImage = imageView.image else {
      imageView.image = newImage
      return
    }

    let animation = CABasicAnimation(keyPath: "contents")
    animation.duration = 0.25
    animation.fromValue = oldImage.cgImage
    animation.toValue = newImage.cgImage
    imageView.layer?.addAnimation(animation, forKey: "transitionAnimation")
    imageView.image = newImage
  }

  public static var postConfigure: ((imageView: NSImageView) -> Void)? = { imageView in
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = imageView.layer?.opacity
    animation.toValue = 1.0
    imageView.layer?.addAnimation(animation, forKey: "fadeAnimation")
    imageView.layer?.opacity = 1.0
  }
}

public var imageCache: Cache<NSImage> {

  struct Static {
    static let config = Config(
      frontKind: .Memory,
      backKind: .Disk,
      expiry: .Date(NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 3)),
      maxSize: 0,
      maxObjects: 10)

    static let cache = Cache<NSImage>(name: "Imaginary", config: config)
  }

  return Static.cache
}
