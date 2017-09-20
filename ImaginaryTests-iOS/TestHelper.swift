import UIKit
@testable import Imaginary

class TestHelper {
  static func image(_ color: UIColor = .red, size: CGSize = .init(width: 10, height: 10)) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)

    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image!
  }
}

class MockDownloader: ImageDownloader {
  var url: URL?
  override func download(url: URL, completion: @escaping (Imaginary.Result) -> Void) {
    self.url = url
    DispatchQueue.global().async {
      completion(.value(TestHelper.image()))
    }
  }
}
