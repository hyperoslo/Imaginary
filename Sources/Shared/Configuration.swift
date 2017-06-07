import Foundation
import Cache

public struct Configuration {

  public static var bytesLoaded: Int = 0

  public static var imageCache: SpecializedCache<Image> = {
    let config = Config(
        expiry: Expiry.date(NSDate().addingTimeInterval(60 * 60 * 24 * 3) as Date),
        memoryCountLimit: 10,
        maxDiskSize: 0)

    return SpecializedCache<Image>(name: "Imaginary", config: config)
  }()
}
