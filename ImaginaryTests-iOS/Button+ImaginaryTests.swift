import XCTest
import Cache
import Imaginary

private final class Button_ImaginaryTests: XCTestCase {
  func testSetImage() {
    let expectation = self.expectation(description: #function)

    let button = UIButton()
    let placeholder = TestHelper.image(.green,
                                       size: CGSize(width: 50, height: 50))
    let mockDownloader = MockDownloader(modifyRequest: { $0 })

    // Mock the Fetcher
    var option = Option(imageDisplayer: ButtonDisplayer())
    option.downloaderMaker = {
      return mockDownloader
    }

    option.storageMaker = {
      return nil
    }

    button.setImage(
      url: URL(string: "https://no.hyper/image.png")!,
      placeholder: placeholder,
      option: option,
      completion: { result in
        switch result {
        case .value(let image):
          // There is returned image
          XCTAssertEqual(image.size, CGSize(width: 10, height: 10))

          // wait a bit until animation completes
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(button.imageView?.image)
            XCTAssertEqual(button.imageView?.image?.size, image.size)
            expectation.fulfill()
          }
        case .error:
          XCTFail()
        }
    })

    // Set to placeholder initially
    XCTAssertEqual(button.imageView?.image?.size, CGSize(width: 50, height: 50))

    wait(for: [expectation], timeout: 1)
  }
}
