import UIKit

/// Used to set image onto ImageView
public class ImageViewDisplayer: ImageDisplayer {

  private let animationOption: UIViewAnimationOptions

  public init(animationOption: UIViewAnimationOptions = .transitionCrossDissolve) {
    self.animationOption = animationOption
  }

  public func display(placeholder: Image, onto view: View) {
    guard let imageView = view as? ImageView else {
      return
    }

    imageView.image = placeholder
  }

  public func display(image: Image, onto view: View) {
    guard let imageView = view as? ImageView else {
      return
    }

    UIView.transition(with: imageView, duration: 0.25,
                      options: [self.animationOption, .allowUserInteraction],
                      animations: {
      imageView.image = image
    }, completion: nil)
  }
}
