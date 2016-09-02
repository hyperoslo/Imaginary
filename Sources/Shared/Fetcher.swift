import Foundation

class Fetcher {

  enum Result {
    case Success(Image)
    case Failure(ErrorType)
  }

  enum Error: ErrorType {
    case InvalidResponse
    case InvalidStatusCode
    case InvalidData
    case InvalidContentLength
    case ConversionError
  }

  let URL: NSURL
  var task: NSURLSessionDataTask?
  var active = false

  var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  // MARK: - Initialization

  init(URL: NSURL) {
    self.URL = URL
  }

  // MARK: - Fetching

  func start(preprocess: Preprocess, completion: (result: Result) -> Void) {
    active = true

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [weak self] in
      guard let weakSelf = self where weakSelf.active else { return }

      weakSelf.task = weakSelf.session.dataTaskWithURL(weakSelf.URL) {
        [weak self] data, response, error -> Void in

        guard let weakSelf = self where weakSelf.active else { return }

        if let error = error {
          weakSelf.complete { completion(result: .Failure(error)) }
          return
        }

        guard let httpResponse = response as? NSHTTPURLResponse else {
          weakSelf.complete { completion(result: .Failure(Error.InvalidResponse)) }
          return
        }

        guard httpResponse.statusCode == 200 else {
          weakSelf.complete { completion(result: .Failure(Error.InvalidStatusCode)) }
          return
        }

        guard let data = data where httpResponse.validateLength(data) else {
          weakSelf.complete { completion(result: .Failure(Error.InvalidContentLength)) }
          return
        }

        guard let decodedImage = Image.decode(data) else {
          weakSelf.complete { completion(result: .Failure(Error.ConversionError)) }
          return
        }

        let image = preprocess(decodedImage)

        if weakSelf.active {
          weakSelf.complete { completion(result: Result.Success(image)) }
        }
      }

      weakSelf.task?.resume()
    }
  }

  func cancel() {
    task?.cancel()
    active = false
  }

  func complete(closure: () -> Void) {
    active = false

    dispatch_async(dispatch_get_main_queue()) {
      closure()
    }
  }
}
