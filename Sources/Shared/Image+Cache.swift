import Foundation
import Cache

extension Image {

  public typealias CacheType = Image

  public static func decode(_ data: Data) -> CacheType? {
    return Decompressor.decompress(data as Data)
  }
}
