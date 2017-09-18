import Foundation
import Cache

public struct Configuration {
  public static var bytesLoaded: Int = 0

  public static var imageStorage: Storage? = {
    let diskConfig = DiskConfig(name: "Imaginary", expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 3)))
    let memoryConfig = MemoryConfig(countLimit: 10, totalCostLimit: 0)

    return try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
  }()
}
