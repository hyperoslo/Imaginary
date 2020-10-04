import Cache

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// Configuration for all operations.
public struct Configuration {

  /// Track how many bytes have been used for downloading
  public static var trackBytesDownloaded = [URL: Int]()

  /// Track if any error occured
  public static var trackError: ((URL, Error) -> Void)?

  /// The default storage
  public static var imageStorage: Storage<String, Image> = {
    let diskConfig = DiskConfig(name: "Imaginary",
                                expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 3)))
    let memoryConfig = MemoryConfig(countLimit: 10, totalCostLimit: 0)

    do {
      return try Storage<String, Image>(
        diskConfig: diskConfig,
        memoryConfig: memoryConfig,
        transformer: TransformerFactory.forImage()
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
}
