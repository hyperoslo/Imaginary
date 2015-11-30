import UIKit

extension UIImageView {

  public func setRemoteImage(URL: NSURL, placeholder: UIImage? = nil) {
    let key = URL.absoluteString
    let imageAddress = "\(unsafeAddressOf(self))"

    image = placeholder

    imageCache.object(key) { [weak self] object in
      guard let weakSelf = self else { return }

      if let image = object {
        dispatch_async(dispatch_get_main_queue()) {
          weakSelf.image = image
        }
        return
      }

      dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
        ImageFetcher.fetch(URL, imageAddress: imageAddress) { [weak self] result in
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
}
