import UIKit
import Cache

extension UIImage {

  public typealias CacheType = UIImage

  public static func decode(data: NSData) -> CacheType? {
    return Decompressor.decompress(data)
  }
}
