import UIKit

final class Decompressor {
  func decompress(data: Data) -> Image? {
    guard let image = Image(data: data) else {
      return nil
    }

    guard let imageRef = image.cgImage, let colorSpaceRef = imageRef.colorSpace else {
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

    let context = CGContext(data: nil,
                            width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent,
                            bytesPerRow: bytesPerRow,
                            space: colorSpaceRef,
                            bitmapInfo: CGBitmapInfo().rawValue)

    context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

    guard let imageRefWithoutAlpha = context?.makeImage() else {
      return image
    }

    return Image(cgImage: imageRefWithoutAlpha)
  }
}
