import Foundation

// Fetch multiple images. This is ideal for prefetching.
public class MultipleImageFetcher {

  private var fetchers: [ImageFetcher] = []
  private let fetcherMaker: () -> ImageFetcher

  init(fetcherMaker: @escaping () -> ImageFetcher) {
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
    var results: [Result] = []

    self.fetchers = urls.map { url in
      let fetcher = self.fetcherMaker()
      fetcher.fetch(url: url, completion: { result in
        each?(result)

        results.append(result)

        if results.count == urls.count {
          completion?(results)
        }
      })

      return fetcher
    }
  }
}
