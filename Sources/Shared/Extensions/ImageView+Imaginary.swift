import Foundation
import Cache

extension ImageView {
  public func setImage(url: URL,
                       placeholder: Image? = nil,
                       option: Option = Option(),
                       completion: Completion? = nil) {
    if let placeholder = placeholder {
      image = placeholder
    }

    if let imageFetcher = imageFetcher {
      imageFetcher.cancel()
      self.imageFetcher = nil
    }

    self.imageFetcher = ImageFetcher(downloader: ImageDownloader(), storage: option.imageStorage)
    self.imageFetcher?.fetch(url: url, completion: { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case .value(let image):
        let processedImage = option.imagePreprocessor?.process(image: image) ?? image
        option.imageDisplayer?.display(image: processedImage, onto: self)
        break
      case .error(let error):
        Configuration.trackError?(url, error)
        break
      }

      completion?(result)
    })
  }

  private var imageFetcher: ImageFetcher? {
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
