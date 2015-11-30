import UIKit

extension UIImageView {

  func setRemoteImage(URL: NSURL, placeholder : UIImage? = nil) {
    let key = URL.absoluteString
    image = placeholder

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      imageCache.object(key) { [weak self] object in
        guard let weakSelf = self else { return }

        if let object = object {
          weakSelf.image = object
          return
        }

        let fetcher = ImageFetcher(URL: URL)

        fetcher.start { [weak self] result in
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
