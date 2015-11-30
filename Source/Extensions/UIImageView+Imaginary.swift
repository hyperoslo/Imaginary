import UIKit

extension UIImageView {

  public func setRemoteImage(URL: NSURL, placeholder: UIImage? = nil) {
    let key = URL.absoluteString

    if let fetcher = fetcher {
      fetcher.cancel()
      self.fetcher = nil
    }

    image = placeholder

    imageCache.object(key) { [weak self] object in
      guard let weakSelf = self else { return }

      if let image = object {
        dispatch_async(dispatch_get_main_queue()) {
          weakSelf.image = image
        }
        return
      }

      weakSelf.fetcher = ImageFetcher(URL: URL)

      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [weak self] result in
        weakSelf.fetcher?.start { [weak self] result in
          guard let weakSelf = self else { return }

          switch result {
          case let .Success(image):
            weakSelf.image = image
            imageCache.add(key, object: image)
          default:
            break
          }
        }
      }
    }
  }

  var fetcher: ImageFetcher? {
    get {
      let wrapper = objc_getAssociatedObject(self, &Capsule.ObjectKey) as? Capsule
      let fetcher = wrapper?.value as? ImageFetcher
      return fetcher
    }
    set (fetcher) {
      var wrapper : Capsule?
      if let fetcher = fetcher {
        wrapper = Capsule(value: fetcher)
      }
      objc_setAssociatedObject(self, &Capsule.ObjectKey,
        wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
