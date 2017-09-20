import XCTest
import Cache
@testable import Imaginary

fileprivate class MockDownloader: ImageDownloader {
  var url: URL?
  override func download(url: URL, completion: @escaping (Imaginary.Result) -> Void) {
    self.url = url
    DispatchQueue.global().async {
      completion(.value(TestHelper.image()))
    }
  }
}

private final class ImageFetcherTests: XCTestCase {
  var storage: Storage!
  var fetcher: ImageFetcher!
  fileprivate var mockDownloader = MockDownloader()
  let url = URL(string: "https://no.hyper/imaginary.png")!

  override func setUp() {
    super.setUp()

    storage = try! Storage(diskConfig: DiskConfig(name: "Floppy"))
    fetcher = ImageFetcher(downloader: mockDownloader, storage: storage)
  }

  override func tearDown() {
    super.tearDown()

    try! storage.removeAll()
  }

  func testDownloadFromNetworkWhenNoCachedObject() {
    let expectation = self.expectation(description: #function)

    // No object in storage
    XCTAssertNil(try? self.storage.object(ofType: ImageWrapper.self, forKey: self.url.absoluteString))

    fetcher.fetch(url: url, completion: { _ in
      // Downloader is triggered
      XCTAssertEqual(self.mockDownloader.url, self.url)

      // Image is saved
      let cachedObject = try? self.storage.object(ofType: ImageWrapper.self, forKey: self.url.absoluteString)
      XCTAssertNotNil(cachedObject)

      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }

  func testObjectFromStorage() {
    let expectation = self.expectation(description: #function)

    // Save object
    try! storage.setObject(ImageWrapper(image: TestHelper.image()), forKey: url.absoluteString)

    // There is cached object
    XCTAssertNotNil(try? self.storage.object(ofType: ImageWrapper.self, forKey: self.url.absoluteString))

    fetcher.fetch(url: url, completion: { _ in
      // Downloader is not triggered
      XCTAssertNil(self.mockDownloader.url)

      // Image is saved
      let cachedObject = try? self.storage.object(ofType: ImageWrapper.self, forKey: self.url.absoluteString)
      XCTAssertNotNil(cachedObject)

      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }
}
