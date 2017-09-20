import Cocoa

final class Decompressor {
  func decompress(data: Data) -> NSImage? {
    guard let image = NSImage(data: data) else {
      return nil
    }

    image.lockFocus()

    var imageRect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    guard let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
      return image
    }

    if imageRef.alphaInfo != .none {
      return image
    }

    let width = imageRef.width
    let height = imageRef.height
    let bytesPerPixel: Int = 4
    let bytesPerRow: Int = bytesPerPixel * width
    let bitsPerComponent: Int = 8

    guard
      let colorSpaceRef = imageRef.colorSpace,
      let context = CGContext(data: nil,
                              width: width,
                              height: height,
                              bitsPerComponent: bitsPerComponent,
                              bytesPerRow: bytesPerRow,
                              space: colorSpaceRef,
                              bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue) else {
                                return image

    }

    context.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

    guard let imageRefWithoutAlpha = context.makeImage() else {
      return NSImage()
    }

    let blendedImage = NSImage(cgImage: imageRefWithoutAlpha, size: NSSize(width: CGFloat(width), height: CGFloat(height)))

    return blendedImage
  }
}
