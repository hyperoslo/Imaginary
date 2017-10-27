import XCTest
import Cache
import Imaginary

private final class SimpleImageDisplayerTests: XCTestCase {
  func testDisplayer() {
    let expectation = self.expectation(description: #function)

    let imageView = UIImageView()
    let displayer: ImageDisplayer = ImageViewDisplayer(animationOption: .transitionFlipFromTop)

    XCTAssertNil(imageView.image)

    // display image
    displayer.display(image: TestHelper.image(), onto: imageView)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      XCTAssertNotNil(imageView.image)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}


