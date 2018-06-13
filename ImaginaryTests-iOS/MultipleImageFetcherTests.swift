import XCTest
import Cache
import Imaginary

private final class MultipleImageFetcherTests: XCTestCase {
  var storage: Storage<Image>!

  override func setUp() {
    super.setUp()

    storage = try! Storage<Image>(diskConfig: DiskConfig(name: "Floppy"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forImage())
  }

  override func tearDown() {
    super.tearDown()

    try! storage.removeAll()
  }

  func testFetcher() {
    let expectation = self.expectation(description: #function)

    let urls: [URL] = [
      URL(string: "https://hyper.no/image.png")!,
      URL(string: "https://hyper.no/image2.png")!,
      URL(string: "https://google.no/image3.png")!,
    ]

    let multipleFetcher = MultipleImageFetcher(fetcherMaker: {
      return ImageFetcher(downloader: MockDownloader(modifyRequest: { $0 }), storage: self.storage)
    })

    multipleFetcher.fetch(urls: urls, each: { result in
      switch result {
      case .error:
        XCTFail()
      default:
        break
      }
    }, completion: { results in
      XCTAssertEqual(results.count, urls.count)
      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 1)
  }
}

