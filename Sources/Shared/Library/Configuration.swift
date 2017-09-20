import Cache

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// Configuration
public struct Configuration {

  /// Track how many bytes have been used for downloading
  public static var bytesLoaded: Int = 0

  /// The image storage, used for caching images in memory and disk
  public var imageStorage: Storage = {
    let diskConfig = DiskConfig(name: "Imaginary", expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 3)))
    let memoryConfig = MemoryConfig(countLimit: 10, totalCostLimit: 0)

    do {
      return try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()

  /// Pre configure imageView before setting image
  public var preConfigure: ((ImageView) -> Void)? = { imageView in
    #if os(iOS) || os(tvOS)
      imageView.layer.opacity = 0.0
    #elseif os(OSX)
      imageView.layer?.opacity = 0.0
    #endif
  }

  /// Animation when new image is set
  public var transitionClosure: ((ImageView, Image) -> Void) = { imageView, newImage in
    #if os(iOS) || os(tvOS)
      guard let oldImage = imageView.image else {
        imageView.image = newImage
        return
      }

      let animation = CABasicAnimation(keyPath: "contents")
      animation.duration = 0.25
      animation.fromValue = oldImage.cgImage
      animation.toValue = newImage.cgImage
      imageView.layer.add(animation, forKey: "transitionAnimation")
      imageView.image = newImage
    #elseif os(OSX)
      guard let oldImage = imageView.image, imageView.window?.inLiveResize == false else {
        imageView.image = newImage
        return
      }

      let animation = CABasicAnimation(keyPath: "contents")
      animation.duration = 0.25
      animation.fromValue = oldImage.cgImage
      animation.toValue = newImage.cgImage
      imageView.wantsLayer = true
      imageView.layer?.add(animation, forKey: "transitionAnimation")
      imageView.image = newImage
    #endif
  }

  /// Post configure imageView after setting image
  public var postConfigure: ((ImageView) -> Void)? = { imageView in
    #if os(iOS) || os(tvOS)
      let animation = CABasicAnimation(keyPath: "opacity")
      animation.fromValue = imageView.layer.opacity
      animation.toValue = 1.0
      imageView.layer.add(animation, forKey: "fadeAnimation")
      imageView.layer.opacity = 1.0
    #elseif os(OSX)
      let animation = CABasicAnimation(keyPath: "opacity")
      animation.fromValue = imageView.layer?.opacity
      animation.toValue = 1.0
      imageView.wantsLayer = true
      imageView.layer?.add(animation, forKey: "fadeAnimation")
      imageView.layer?.opacity = 1.0
    #endif
  }

  /// Track the url for error
  public var track: ((URL?, Error?) -> Void)?

  /// Initialization
  public init() {}

  /// The default configuration applied to every image request
  public static var `default` = Configuration()
}
