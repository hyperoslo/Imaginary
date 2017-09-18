import Foundation
import Cache

extension ImageView {
  public func setImage(url: URL?,
                       placeholder: Image? = nil,
                       preprocess: @escaping Preprocess = { image in return image },
                       completion: Completion? = nil) {
    image = placeholder

    guard let url = url else {
      return
    }

    if let fetcher = fetcher {
      fetcher.cancel()
      self.fetcher = nil
    }

    Configuration.imageStorage?.async.object(ofType: ImageWrapper.self,
                                             forKey: url.absoluteString) { [weak self] result in
      guard let `self` = self else {
        return
      }

      if case .value(let wrapper) = result {
        DispatchQueue.main.async {
          Configuration.transitionClosure(self, wrapper.image)
          completion?(wrapper.image)
        }

        return
      }

      if placeholder == nil {
        DispatchQueue.main.async {
          Configuration.preConfigure?(self)
        }
      }

      DispatchQueue.main.async {
        self.fetchFromNetwork(url: url, preprocess: preprocess, completion: completion)
      }
    }
  }

  fileprivate func fetchFromNetwork(url: URL, preprocess: @escaping Preprocess, completion: Completion? = nil) {
    fetcher = Fetcher(url: url)
    fetcher?.start(preprocess) { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case let .success(image, bytes):
        Configuration.track?(url, nil, bytes)
        Configuration.transitionClosure(self, image)
        let wrapper = ImageWrapper(image: image)
        Configuration.imageStorage?.async.setObject(wrapper, forKey: url.absoluteString, expiry: nil) { _ in
          // Don't care about result for now
        }
        completion?(image)
      case let .failure(error):
        Configuration.track?(url, error, 0)
      }

      Configuration.postConfigure?(self)
    }
  }

  var fetcher: Fetcher? {
    get {
      let wrapper = objc_getAssociatedObject(self, &Capsule.ObjectKey) as? Capsule
      let fetcher = wrapper?.concept as? Fetcher
      return fetcher
    }
    set (fetcher) {
      var wrapper: Capsule?
      if let fetcher = fetcher {
        wrapper = Capsule(concept: fetcher)
      }
      objc_setAssociatedObject(self, &Capsule.ObjectKey,
                               wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
