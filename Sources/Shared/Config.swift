import Foundation
import Cache

public struct Configuration {

  public static var imageCache: Cache<Image> = {
    let config = Config(
        frontKind: .Memory,
        backKind: .Disk,
        expiry: .Date(NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 3)),
        maxSize: 0,
        maxObjects: 10)

    return Cache<Image>(name: "Imaginary", config: config)
  }()
}
