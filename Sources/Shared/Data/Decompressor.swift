import Cocoa

struct Decompressor {

  static func decompress(data: NSData, scale: CGFloat = 1) -> NSImage {
    guard let image = NSImage(data: data) else { return NSImage() }

    image.lockFocus()

    var imageRect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    let imageRef = image.CGImageForProposedRect(&imageRect, context: nil, hints: nil)

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
    CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)

    guard let imageRefWithoutAlpha = CGBitmapContextCreateImage(context) else {
      return NSImage()
    }
    let blendedImage = NSImage(CGImage: imageRefWithoutAlpha, size: NSSize(width: CGFloat(width), height: CGFloat(height)))

    return blendedImage
  }
}
