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

  static var task: NSURLSessionDataTask?

  static var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  // MARK: - Fetching

  public static func fetch(URL: NSURL, completion: (result: Result) -> Void) -> NSURLSessionDataTask? {
    let task = session.dataTaskWithURL(URL) { data, response, error -> Void in
      if let error = error {
        complete { completion(result: .Failure(error)) }
        return
      }

      guard let httpResponse = response as? NSHTTPURLResponse else {
        complete { completion(result: .Failure(Error.InvalidResponse)) }
        return
      }

      guard httpResponse.statusCode == 200 else {
        complete { completion(result: .Failure(Error.InvalidStatusCode)) }
        return
      }

      guard let data = data where httpResponse.validateLength(data) else {
        complete { completion(result: .Failure(Error.InvalidStatusCode)) }
        return
      }

      guard let image = UIImage.decode(data) else {
        complete { completion(result: .Failure(Error.ConvertionError)) }
        return
      }

      complete { completion(result: Result.Success(image)) }
    }

    task.resume()

    return task
  }

  static func complete(closure: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
      closure()
    }
  }
}
