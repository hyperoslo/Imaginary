import Foundation

class Fetcher {

  enum Result {
    case success(image: Image, byteCount: Int)
    case failure(Error)
  }

  enum Failure: Error {
    case invalidResponse
    case invalidStatusCode
    case invalidData
    case invalidContentLength
    case conversionError
  }

  let url: URL
  var task: URLSessionDataTask?
  var active = false

  var session: URLSession {
    return URLSession.shared
  }

  // MARK: - Initialization

  init(url: URL) {
    self.url = url
  }

  // MARK: - Fetching

  func start(_ preprocess: @escaping Preprocess, completion: @escaping (_ result: Result) -> Void) {
    active = true

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] in
      guard let weakSelf = self, weakSelf.active else { return }

      weakSelf.task = weakSelf.session.dataTask(with: weakSelf.url, completionHandler: {
        [weak self] data, response, error -> Void in

        guard let weakSelf = self, weakSelf.active else { return }

        if let error = error {
          weakSelf.complete { completion(.failure(error)) }
          return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
          weakSelf.complete { completion(.failure(Failure.invalidResponse)) }
          return
        }

        guard httpResponse.statusCode == 200 else {
          weakSelf.complete { completion(.failure(Failure.invalidStatusCode)) }
          return
        }

        guard let data = data, httpResponse.validateLength(data) else {
          weakSelf.complete { completion(.failure(Failure.invalidContentLength)) }
          return
        }

        guard let decodedImage = Image.decode(data) else {
          weakSelf.complete { completion(.failure(Failure.conversionError)) }
          return
        }

        let image = preprocess(decodedImage)

        Configuration.bytesLoaded += data.count

        if weakSelf.active {
          weakSelf.complete {
            completion(Result.success(image: image, byteCount: data.count))
          }
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
