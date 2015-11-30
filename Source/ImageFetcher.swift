import UIKit
import Foundation

class Fetcher {

  enum Result {
    case Success(UIImage)
    case Failure(ErrorType)
  }

  enum Error: ErrorType {
    case InvalidResponse
    case InvalidStatusCode
    case InvalidData
    case ConvertionError
  }

  let URL: NSURL
  var fetchTask: NSURLSessionDataTask?
  var decompressionTask: BackgroundTask?
  var active = false

  var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  // MARK: - Initialization

  init(URL: NSURL) {
    self.URL = URL
  }

  // MARK: - Fetching

  func start(completion: (result: Result) -> Void) {
    active = true

    BackgroundTask(processing: { [weak self] in
      guard let weakSelf = self where weakSelf.active else { return }

      weakSelf.fetchTask = weakSelf.session.dataTaskWithURL(weakSelf.URL) {
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
          weakSelf.complete { completion(result: .Failure(Error.InvalidStatusCode)) }
          return
        }

        weakSelf.decompressionTask = BackgroundTask(processing: { [weak self] in
          guard let weakSelf = self where weakSelf.active else { return }

          guard let image = UIImage.decode(data) else {
            weakSelf.complete { completion(result: .Failure(Error.ConvertionError)) }
            return
          }

          weakSelf.complete { completion(result: Result.Success(image)) }
        }).start()
      }

      weakSelf.fetchTask?.resume()
    }).start()
  }

  func cancel() {
    fetchTask?.cancel()
    decompressionTask?.cancel()
    active = false
  }

  func complete(closure: () -> Void) {
    active = false
    
    dispatch_async(dispatch_get_main_queue()) {
      closure()
    }
  }
}
