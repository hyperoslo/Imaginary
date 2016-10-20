import UIKit

// MARK: - Tint effect

public struct TintDrawer: ImageDrawer {

  public let tintColor: UIColor

  public init(tintColor: UIColor) {
    self.tintColor = tintColor
  }

  public func draw(_ image: UIImage, context: CGContext, rect: CGRect) {
    guard let cgImage = image.cgImage else {
      return
    }

    context.setBlendMode(.normal)
    UIColor.black.setFill()
    context.fill(rect)

    context.setBlendMode(.normal)
    context.draw(cgImage, in: rect)

    context.setBlendMode(.color)
    tintColor.setFill()
    context.fill(rect)

    context.setBlendMode(.destinationIn)
    context.draw(cgImage, in: rect)
  }
}
