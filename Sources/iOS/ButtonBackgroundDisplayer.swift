#if canImport(UIKit)
import UIKit

/// Used to set background image onto Button
public class ButtonBackgroundDisplayer: ImageDisplayer {
  public init() {}

  public func display(placeholder: Image, onto view: View) {
    guard let button = view as? Button else {
      return
    }

    button.setBackgroundImage(placeholder, for: .normal)
  }

  public func display(image: Image, onto view: View) {
    guard let button = view as? Button else {
      return
    }

    UIView.transition(with: button, duration: 0.25,
                      options: [.transitionCrossDissolve, .allowUserInteraction],
                      animations: {
      button.setBackgroundImage(image, for: .normal)
    }, completion: nil)
  }
}
#endif
