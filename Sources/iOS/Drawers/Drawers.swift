import UIKit

// MARK: - Tint effect

public struct TintDrawer: ImageDrawer {

  public let tintColor: UIColor

  public init(tintColor: UIColor) {
    self.tintColor = tintColor
  }

  public func draw(_ image: UIImage, context: CGContext, rect: CGRect) {
    context.setBlendMode(.normal)
    UIColor.black.setFill()
    context.fill(rect)

    context.setBlendMode(.normal)
    context.draw(image.cgImage!, in: rect)

    context.setBlendMode(.color)
    tintColor.setFill()
    context.fill(rect)

    context.setBlendMode(.destinationIn)
    context.draw(image.cgImage!, in: rect)
  }
}
