import Foundation
import Cache

extension ImageView {
  public func setImage(url: URL,
                       placeholder: Image? = nil,
                       configuration: Configuration = Configuration.default,
                       completion: Completion? = nil) {
    if let placeholder = placeholder {
      image = placeholder
    }

    if let imageFetcher = imageFetcher {
      imageFetcher.cancel()
      self.imageFetcher = nil
    }

    self.imageFetcher = ImageFetcher(downloader: ImageDownloader(), storage: configuration.imageStorage)
    self.imageFetcher?.fetch(url: url, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      configuration.preConfigure?(self)

      switch result {
      case .value(let image):
        configuration.transitionClosure(self, image)
        break
      case .error(let error):
        configuration.track?(url, error)
        break
      }

      configuration.postConfigure?(self)

      completion?(result)
    })
  }

  var imageFetcher: ImageFetcher? {
    get {
      return objc_getAssociatedObject(self, &AssociateKey.fetcher) as? ImageFetcher
    }
    set {
      objc_setAssociatedObject(self, &AssociateKey.fetcher,
                               newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

/// Used for associate ImageFetcher with ImageView
fileprivate struct AssociateKey {
  static var fetcher = 0
}
