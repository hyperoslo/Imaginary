import UIKit
import Cache

public extension Configuration {

  public static var preConfigure: ((_ imageView: UIImageView) -> Void)? = { imageView in
    imageView.layer.opacity = 0.0
  }

  public static var transitionClosure: ((_ imageView: UIImageView, _ image: UIImage) -> Void) = { imageView, newImage in
    guard let oldImage = imageView.image else {
      imageView.image = newImage
      return
    }

    let animation = CABasicAnimation(keyPath: "contents")
    animation.duration = 0.25
    animation.fromValue = oldImage.cgImage
    animation.toValue = newImage.cgImage
    imageView.layer.add(animation, forKey: "transitionAnimation")
    imageView.image = newImage
  }

  public static var postConfigure: ((_ imageView: UIImageView) -> Void)? = { imageView in
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = imageView.layer.opacity
    animation.toValue = 1.0
    imageView.layer.add(animation, forKey: "fadeAnimation")
    imageView.layer.opacity = 1.0
  }
  
  public static var track: ((URL?, Error?, Int) -> Void)?
}
