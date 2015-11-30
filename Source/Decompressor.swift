import UIKit

public struct Decompressor {

  public static func decompress(data: NSData, scale: CGFloat = 1) -> UIImage {
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

public class BackgroundTask {

  private var block: dispatch_block_t

  init(processing: () -> Void) {
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
      processing()
    }
  }

  func start() -> BackgroundTask {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), block)
    return self
  }

  func cancel() {
    dispatch_block_cancel(block)
  }
}
