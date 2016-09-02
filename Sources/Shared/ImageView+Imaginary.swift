import Foundation

public typealias Preprocess = Image -> Image

extension ImageView {

  public func setImage(URL: NSURL?,
                       placeholder: Image? = nil,
                       preprocess: Preprocess = { image in return image },
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
        dispatch_async(dispatch_get_main_queue()) {
          weakSelf.image = image
          completion?(image)
        }

        return
      }

      if placeholder == nil {
        Configuration.preConfigure?(imageView: weakSelf)
      }

      weakSelf.fetcher = Fetcher(URL: URL)

      weakSelf.fetcher?.start(preprocess) { [weak self] result in
        guard let weakSelf = self else { return }

        switch result {
        case let .Success(image):
          Configuration.transitionClosure(imageView: weakSelf, image: image)
          Configuration.imageCache.add(key, object: image)
          completion?(image)
        default:
          break
        }
        Configuration.postConfigure?(imageView: weakSelf)
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
