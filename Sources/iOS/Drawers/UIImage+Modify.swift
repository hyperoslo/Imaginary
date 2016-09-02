import UIKit

public extension UIImage {

  func modify(with drawers: ImageDrawer...) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)

    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }

    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    CGContextTranslateCTM(context, 0, size.height)
    CGContextScaleCTM(context, 1.0, -1.0)

    for drawer in drawers {
      drawer.draw(self, context: context, rect: rect)
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}
