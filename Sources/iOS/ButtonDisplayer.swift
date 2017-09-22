import UIKit

/// Used to set image onto Button
public class ButtonDisplayer: ImageDisplayer {
  public init() {}

  public func display(placeholder: Image, onto view: View) {
    guard let button = view as? Button else {
      return
    }

    button.setImage(placeholder, for: .normal)
  }

  public func display(image: Image, onto view: View) {
    guard let button = view as? Button else {
      return
    }

    UIView.transition(with: button, duration: 0.25,
                      options: [.transitionCrossDissolve, .allowUserInteraction],
                      animations: {
      button.setImage(image, for: .normal)
    }, completion: nil)
  }
}
