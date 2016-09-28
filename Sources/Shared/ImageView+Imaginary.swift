import Foundation

public typealias Preprocess = (Image) -> Image

extension ImageView {

  public func setImage(_ URL: Foundation.URL?,
                       placeholder: Image? = nil,
                       preprocess: @escaping Preprocess = { image in return image },
                       completion: ((Image?) -> ())? = nil) {
    image = placeholder

    guard let URL = URL else { return }

    let key = URL.absoluteString

    if let fetcher = fetcher {
      fetcher.cancel()
      self.fetcher = nil
    }

    Configuration.imageCache.object(key) { [weak self] object in
      guard let weakSelf = self else { return }

      if let image = object {
        DispatchQueue.main.async {
          weakSelf.image = image
          completion?(image)
        }

        return
      }

      if placeholder == nil {
        Configuration.preConfigure?(weakSelf)
      }

      weakSelf.fetcher = Fetcher(URL: URL)

      weakSelf.fetcher?.start(preprocess) { [weak self] result in
        guard let weakSelf = self else { return }

        switch result {
        case let .success(image):
          Configuration.transitionClosure(weakSelf, image)
          Configuration.imageCache.add(key, object: image)
          completion?(image)
        default:
          break
        }
        Configuration.postConfigure?(weakSelf)
      }
    }
  }

  var fetcher: Fetcher? {
    get {
      let wrapper = objc_getAssociatedObject(self, &Capsule.ObjectKey) as? Capsule
      let fetcher = wrapper?.value as? Fetcher
      return fetcher
    }
    set (fetcher) {
      var wrapper: Capsule?
      if let fetcher = fetcher {
        wrapper = Capsule(value: fetcher)
      }
      objc_setAssociatedObject(self, &Capsule.ObjectKey,
                               wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
