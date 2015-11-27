import UIKit

public struct Decompressor {

  public func decompress(data: NSData, scale: CGFloat = 1, completion: (image: UIImage) -> Void) {
    autoreleasepool({
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
        guard let image = UIImage(data: data) else { completion(image: UIImage()); return }

        let reference = image.CGImage

        if CGImageGetAlphaInfo(reference) != .None { dispatch_async(dispatch_get_main_queue(), { completion(image: image) }) }

        let context = CGBitmapContextCreate(nil,
          Int(image.size.width), Int(image.size.height), CGImageGetBitsPerComponent(reference),
          0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.None.rawValue)
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), reference)

        var blendedImage = UIImage()
        if let referenceImage = CGBitmapContextCreateImage(context) {
          blendedImage = UIImage(CGImage: referenceImage, scale: scale, orientation: image.imageOrientation)
        }

        UIGraphicsEndImageContext()

        dispatch_async(dispatch_get_main_queue(), { completion(image: blendedImage) })
      })
    })
  }
}
