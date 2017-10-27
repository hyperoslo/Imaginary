import Foundation

// Fetch multiple images. This is ideal for prefetching.
public class MultipleImageFetcher {

  private var fetchers: [ImageFetcher] = []
  private let fetcherMaker: () -> ImageFetcher

  public init(fetcherMaker: @escaping () -> ImageFetcher) {
    self.fetcherMaker = fetcherMaker
  }

  /// Fetch multiple urls at once
  ///
  /// - Parameters:
  ///   - urls: The urls to fetch
  ///   - each: Called after each fetcher completed
  ///   - completion: Called after all fetchers completed
  public func fetch(urls: [URL],
                    each: ((Result) -> Void)? = nil,
                    completion: (([Result]) -> Void)? = nil) {
    self.fetchers = urls.map { _ in
      return self.fetcherMaker()
    }

    var results: [Result] = []

    zip(fetchers, urls).forEach { fetcher, url in
      fetcher.fetch(url: url, completion: { result in
        each?(result)

        results.append(result)

        if results.count == urls.count {
          completion?(results)
        }
      })
    }
  }

  /// Cancel all operations
  public func cancel() {
    fetchers.forEach {
      $0.cancel()
    }

    fetchers.removeAll()
  }
}
