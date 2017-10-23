import Foundation

/// Download image from url
public class ImageDownloader {
  fileprivate let session: URLSession

  fileprivate var task: URLSessionDataTask?
  fileprivate var active = false

  // MARK: - Initialization

  public init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  // MARK: - Operation

  public func download(url: URL, completion: @escaping (Result) -> Void) {
    active = true

    self.task = self.session.dataTask(with: url,
                                      completionHandler: { [weak self] data, response, error in
      guard let `self` = self, self.active else {
        return
      }

      defer {
        self.active = false
      }

      if let error = error {
        completion(.error(error))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.error(ImaginaryError.invalidResponse))
        return
      }

      guard httpResponse.statusCode == 200 else {
        completion(.error(ImaginaryError.invalidStatusCode))
        return
      }

      guard let data = data, httpResponse.validateLength(data) else {
        completion(.error(ImaginaryError.invalidContentLength))
        return
      }

      guard let decodedImage = Decompressor().decompress(data: data) else {
        completion(.error(ImaginaryError.conversionError))
        return
      }

      Configuration.trackBytesDownloaded[url] = data.count
      completion(.value(decodedImage))
    })

    self.task?.resume()
  }

  func cancel() {
    task?.cancel()
    active = false
  }
}

fileprivate extension HTTPURLResponse {
  func validateLength(_ data: Data) -> Bool {
    return expectedContentLength > -1
      ? (Int64(data.count) >= expectedContentLength)
      : true
  }
}
