import UIKit

public struct Decompressor {

  public func decompress(data: NSData, scale: CGFloat = 1, completion: (image: UIImage) -> Void) {
    autoreleasepool({
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
        guard let image = UIImage(data: data) else { completion(image: UIImage()); return }

        let reference = image.CGImage

        if CGImageGetAlphaInfo(reference) != .None { dispatch_async(dispatch_get_main_queue(), { completion(image: image) }) }

        UIGraphicsBeginImageContextWithOptions(image.size, true, scale)
        image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        dispatch_async(dispatch_get_main_queue(), { completion(image: blendedImage) })
      })
    })
  }
}
