import UIKit

extension UIImageView {

  func setRemoteImage(URL: NSURL, placeholder : UIImage? = nil) {
    let key = URL.absoluteString
    image = placeholder

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
      imageCache.object(key) { [weak self] object in
        guard let weakSelf = self else { return }

        if let image = object {
          dispatch_async(dispatch_get_main_queue()) {
            weakSelf.image = image
          }
          return
        }

        let fetcher = ImageFetcher(URL: URL)

        fetcher.start { [weak self] result in
          guard let weakSelf = self else { return }

          switch result {
          case let .Success(image):
            dispatch_async(dispatch_get_main_queue()) {
              weakSelf.image = image
            }
            imageCache.add(key, object: image)
          default:
            break
          }
        }
      }
    }
  }
}
