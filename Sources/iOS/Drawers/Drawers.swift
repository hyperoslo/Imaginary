import UIKit

public protocol ImageDrawer {
  func draw(image: UIImage, context: CGContext, rect: CGRect)
}

// MARK: - Tint effect

public struct TintDrawer: ImageDrawer {

  public let tintColor: UIColor

  public init(tintColor: UIColor) {
    self.tintColor = tintColor
  }

  public func draw(image: UIImage, context: CGContext, rect: CGRect) {
    CGContextSetBlendMode(context, .Normal)
    UIColor.blackColor().setFill()
    CGContextFillRect(context, rect)

    CGContextSetBlendMode(context, .Normal)
    CGContextDrawImage(context, rect, image.CGImage)

    CGContextSetBlendMode(context, .Color)
    tintColor.setFill()
    CGContextFillRect(context, rect)

    CGContextSetBlendMode(context, .DestinationIn)
    CGContextDrawImage(context, rect, image.CGImage)
  }
}
