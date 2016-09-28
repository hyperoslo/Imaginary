import UIKit

public extension UIImage {

  func modify(with drawers: [ImageDrawer]) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)

    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }

    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)

    for drawer in drawers {
      drawer.draw(self, context: context, rect: rect)
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}
