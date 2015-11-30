import UIKit
import Foundation

public class ImageFetcher {

  public enum Result {
    case Success(UIImage)
    case Failure(ErrorType)
  }

  public enum Error: ErrorType {
    case InvalidResponse
    case InvalidStatusCode
    case InvalidData
    case ConvertionError
  }

  public let URL: NSURL
  var task: NSURLSessionDataTask?
  var active = false

  public var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  // MARK: - Initialization

  public init(URL: NSURL) {
    self.URL = URL
  }

  // MARK: - Fetching

  public func start(completion: (result: Result) -> Void) {
    active = true

    task = session.dataTaskWithURL(URL) { [weak self] data, response, error -> Void in
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

      guard let image = UIImage.decode(data) else {
        weakSelf.complete { completion(result: .Failure(Error.ConvertionError)) }
        return
      }

      weakSelf.complete { completion(result: Result.Success(image)) }
    }

    task?.resume()
  }

  public func cancel() {
    task?.cancel()
    active = false
  }

  func complete(closure: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
      closure()
    }
  }
}
