import Foundation
import Cache

public struct Configuration {

  public static var bytesLoaded: Int = 0
  public static var imageCache: Cache<Image> = {
    let config = Config(
        frontKind: .memory,
        backKind: .disk,
        expiry: Expiry.date(NSDate().addingTimeInterval(60 * 60 * 24 * 3) as Date),
        maxSize: 0,
        maxObjects: 10)

    return Cache<Image>(name: "Imaginary", config: config)
  }()
}
