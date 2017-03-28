import Foundation

public typealias Preprocess = (Image) -> Image
public typealias Completion = (Image?) -> Void

extension ImageView {

  public func setImage(url: URL?,
                       placeholder: Image? = nil,
                       preprocess: @escaping Preprocess = { image in return image },
                       completion: Completion? = nil) {
    image = placeholder

    guard let url = url else { return }

    if let fetcher = fetcher {
      fetcher.cancel()
      self.fetcher = nil
    }

    Configuration.imageCache.object(url.absoluteString) { [weak self] (object: Image?) in
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

      DispatchQueue.main.async {
        weakSelf.fetchFromNetwork(url: url, preprocess: preprocess, completion: completion)
      }
    }
  }

  fileprivate func fetchFromNetwork(url: URL,
                                    preprocess: @escaping Preprocess,
                                    completion: Completion? = nil) {
    fetcher = Fetcher(url: url)

    fetcher?.start(preprocess) { [weak self] result in
      guard let weakSelf = self else { return }

      switch result {
      case let .success(image, bytes):
        Configuration.track?(url, nil, bytes)
        Configuration.transitionClosure(weakSelf, image)
        Configuration.imageCache.add(url.absoluteString, object: image)
        completion?(image)
      case let .failure(error):
        Configuration.track?(url, error, 0)
      }

      Configuration.postConfigure?(weakSelf)
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
