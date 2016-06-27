import Foundation
import Cache

extension Image {

  public typealias CacheType = Image

  public static func decode(data: NSData) -> CacheType? {
    return Decompressor.decompress(data)
  }
}
