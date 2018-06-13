import XCTest
import Cache
@testable import Imaginary

private final class ImageFetcherTests: XCTestCase {
  var storage: Storage<Image>!
  var fetcher: ImageFetcher!
  fileprivate var mockDownloader = MockDownloader(modifyRequest: { $0 })
  let url = URL(string: "https://no.hyper/imaginary.png")!

  override func setUp() {
    super.setUp()

    storage = try! Storage<Image>(diskConfig: DiskConfig(name: "Floppy"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forImage())
    fetcher = ImageFetcher(downloader: mockDownloader, storage: storage)
  }

  override func tearDown() {
    super.tearDown()

    try! storage.removeAll()
  }

  func testDownloadFromNetworkWhenNoCachedObject() {
    let expectation = self.expectation(description: #function)

    // No object in storage
    XCTAssertNil(try? self.storage.object(forKey: self.url.absoluteString))

    fetcher.fetch(url: url, completion: { _ in
      // Downloader is triggered
      XCTAssertEqual(self.mockDownloader.url, self.url)

      // Image is saved
      let cachedObject = try? self.storage.object(forKey: self.url.absoluteString)
      XCTAssertNotNil(cachedObject)

      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }

  func testObjectFromStorage() {
    let expectation = self.expectation(description: #function)

    // Save object
    try! storage.setObject(TestHelper.image(), forKey: url.absoluteString)

    // There is cached object
    XCTAssertNotNil(try? self.storage.object(forKey: self.url.absoluteString))

    fetcher.fetch(url: url, completion: { _ in
      // Downloader is not triggered
      XCTAssertNil(self.mockDownloader.url)

      // Image is saved
      let cachedObject = try? self.storage.object(forKey: self.url.absoluteString)
      XCTAssertNotNil(cachedObject)

      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }
}
