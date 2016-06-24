import Cocoa
import Cache

extension NSImage {

  public typealias CacheType = NSImage

  public static func decode(data: NSData) -> CacheType? {
    return Decompressor.decompress(data)
  }
}
