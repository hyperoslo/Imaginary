import Foundation

/// How to display image onto imageView
public protocol ImageDisplaying {
  func display(image: Image, onto imageView: ImageView)
}
