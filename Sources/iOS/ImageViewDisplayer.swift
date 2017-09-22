import UIKit

public class SimpleImageDisplayer: ImageDisplaying {

  private let animationOption: UIViewAnimationOptions

  public init(animationOption: UIViewAnimationOptions = .transitionCrossDissolve) {
    self.animationOption = animationOption
  }

  public func display(image: Image, onto imageView: ImageView) {
    UIView.transition(with: imageView, duration: 0.25,
                      options: [self.animationOption, .allowUserInteraction],
                      animations: {
      imageView.image = image
    }, completion: nil)
  }
}
