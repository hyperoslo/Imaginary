import Foundation
import Cache

extension ImageView {
  public func setImage(url: URL?,
                       placeholder: Image? = nil,
                       configuration: Configuration = Configuration.default,
                       completion: Completion? = nil) {
    image = placeholder

    guard let url = url else {
      return
    }

    if let imageDownloader = imageDownloader {
      imageDownloader.cancel()
      self.imageDownloader = nil
    }

    configuration.imageStorage.async.object(ofType: ImageWrapper.self,
                                             forKey: url.absoluteString) { [weak self] result in
      guard let `self` = self else {
        return
      }

      if case .value(let wrapper) = result {
        DispatchQueue.main.async {
          configuration.transitionClosure(self, wrapper.image)
          completion?(.image(wrapper.image))
        }

        return
      }

      if placeholder == nil {
        DispatchQueue.main.async {
          configuration.preConfigure?(self)
        }
      }

      DispatchQueue.main.async {
        self.fetchFromNetwork(url: url, configuration: configuration, completion: completion)
      }
    }
  }

  fileprivate func fetchFromNetwork(url: URL, configuration: Configuration = Configuration.default, completion: Completion? = nil) {
    imageDownloader = ImageDownloader()
    imageDownloader?.download(url: url) { [weak self] result in
      guard let `self` = self else {
        return
      }

      switch result {
      case .image(let image):
        configuration.track?(url, nil)
        configuration.transitionClosure(self, image)
        let wrapper = ImageWrapper(image: image)
        configuration.imageStorage.async.setObject(wrapper, forKey: url.absoluteString, expiry: nil) { _ in
          // Don't care about result for now
        }
        completion?(.image(image))
      case .error(let error):
        completion?(.error(error))
        configuration.track?(url, error)
      }

      configuration.postConfigure?(self)
    }
  }

  var imageDownloader: ImageDownloader? {
    get {
      let wrapper = objc_getAssociatedObject(self, &Capsule.ObjectKey) as? Capsule
      let imageDownloader = wrapper?.concept as? ImageDownloader
      return imageDownloader
    }
    set (imageDownloader) {
      var wrapper: Capsule?
      if let imageDownloader = imageDownloader {
        wrapper = Capsule(concept: imageDownloader)
      }
      objc_setAssociatedObject(self, &Capsule.ObjectKey,
                               wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}


/// Used to associate ImageDownloader with ImageView
fileprivate class Capsule: NSObject {
  static var ObjectKey = 0
  let concept: Any

  init(concept: Any) {
    self.concept = concept
  }
}
