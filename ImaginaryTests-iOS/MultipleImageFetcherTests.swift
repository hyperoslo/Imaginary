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

private final class MultipleImageFetcherTests: XCTestCase {
  var storage: Storage!

  override func setUp() {
    super.setUp()

    storage = try! Storage(diskConfig: DiskConfig(name: "Floppy"))
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
      return ImageFetcher(downloader: MockDownloader(), storage: self.storage)
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

