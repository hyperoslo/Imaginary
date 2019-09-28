#if canImport(UIKit)
import UIKit

/// Apply tint color to image
public class TintImageProcessor: ImageProcessor {
  private let tintColor: UIColor

  public init(tintColor: UIColor) {
    self.tintColor = tintColor
  }

  public func process(image: Image) -> Image {
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)

    guard let context = UIGraphicsGetCurrentContext() else {
      return image
    }

    let rect = CGRect(x: 0, y: 0,
                      width: image.size.width,
                      height: image.size.height)

    context.translateBy(x: 0, y: image.size.height)
    context.scaleBy(x: 1.0, y: -1.0)

    apply(tintColor: tintColor,
          onto: image,
          context: context, rect: rect)

    let processedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return processedImage ?? image
  }

  private func apply(tintColor: UIColor,
                     onto image: UIImage,
                     context: CGContext,
                     rect: CGRect) {
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
#endif
