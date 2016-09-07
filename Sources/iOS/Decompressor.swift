import UIKit

struct Decompressor {

  static func decompress(data: NSData, scale: CGFloat = 1) -> Image {
    guard let image = Image(data: data) else { return Image() }
    return image
  }
}
