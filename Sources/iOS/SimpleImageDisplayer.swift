import UIKit

public class SimpleImageDisplayer: ImageDisplaying {
  public func display(image: Image, onto imageView: ImageView) {
    guard let oldImage = imageView.image else {
      imageView.image = image
      return
    }

    let animation = CABasicAnimation(keyPath: "contents")
    animation.duration = 0.25
    animation.fromValue = oldImage.cgImage
    animation.toValue = image.cgImage
    imageView.layer.add(animation, forKey: "transitionAnimation")
    imageView.image = image
  }
}
