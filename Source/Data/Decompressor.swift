import UIKit

struct Decompressor {

  static func decompress(data: NSData, scale: CGFloat = 1) -> UIImage {
    guard let image = UIImage(data: data) else { return UIImage() }

    let reference = image.CGImage

    if CGImageGetAlphaInfo(reference) != .None { return image }

    UIGraphicsBeginImageContextWithOptions(image.size, true, scale)

    let context = UIGraphicsGetCurrentContext()
    CGContextSetRGBFillColor(context, 1, 1, 1, 1)
    CGContextFillRect(context, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    CGContextSaveGState(context)

    let blendedImage = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return blendedImage
  }
}
