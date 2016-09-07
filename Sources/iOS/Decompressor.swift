import UIKit

struct Decompressor {

  static func decompress(data: NSData, scale: CGFloat = 1) -> Image {
    guard let image = Image(data: data) else { return Image() }

    let imageRef = image.CGImage

    if CGImageGetAlphaInfo(imageRef) != .None { return image }

    let colorSpaceRef = CGImageGetColorSpace(imageRef)
    let width = CGImageGetWidth(imageRef)
    let height = CGImageGetHeight(imageRef)
    let bytesPerPixel: Int = 4
    let bytesPerRow: Int = bytesPerPixel * width
    let bitsPerComponent: Int = 8

    let context = CGBitmapContextCreate(nil,
                                        width,
                                        height,
                                        bitsPerComponent,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        CGBitmapInfo.ByteOrderDefault.rawValue)
    CGContextDrawImage(context, CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)), imageRef)

    guard let imageRefWithoutAlpha = CGBitmapContextCreateImage(context) else {
      return image
    }

    return Image(CGImage: imageRefWithoutAlpha)
  }
}
