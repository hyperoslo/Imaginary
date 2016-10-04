import Foundation

class Fetcher {

  enum Result {
    case success(Image)
    case failure(Error)
  }

  enum Error {
    case invalidResponse
    case invalidStatusCode
    case invalidData
    case invalidContentLength
    case conversionError
  }

  let URL: Foundation.URL
  var task: URLSessionDataTask?
  var active = false

  var session: URLSession {
    return URLSession.shared
  }

  // MARK: - Initialization

  init(URL: Foundation.URL) {
    self.URL = URL
  }

  // MARK: - Fetching

  func start(_ preprocess: @escaping Preprocess, completion: @escaping (_ result: Result) -> Void) {
    active = true

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] in
      guard let weakSelf = self, weakSelf.active else { return }

      weakSelf.task = weakSelf.session.dataTask(with: weakSelf.URL, completionHandler: {
        [weak self] data, response, error -> Void in

        guard let weakSelf = self, weakSelf.active else { return }

        if let error = error {
          weakSelf.complete { completion(.failure(error as! Fetcher.Error)) }
          return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
          weakSelf.complete { completion(.failure(Error.invalidResponse)) }
          return
        }

        guard httpResponse.statusCode == 200 else {
          weakSelf.complete { completion(.failure(Error.invalidStatusCode)) }
          return
        }

        guard let data = data, httpResponse.validateLength(data) else {
          weakSelf.complete { completion(.failure(Error.invalidContentLength)) }
          return
        }

        guard let decodedImage = Image.decode(data) else {
          weakSelf.complete { completion(.failure(Error.conversionError)) }
          return
        }

        let image = preprocess(decodedImage)

        if weakSelf.active {
          weakSelf.complete { completion(Result.success(image)) }
        }
      })

      weakSelf.task?.resume()
    }
  }

  func cancel() {
    task?.cancel()
    active = false
  }

  func complete(_ closure: @escaping () -> Void) {
    active = false

    DispatchQueue.main.async {
      closure()
    }
  }
}
