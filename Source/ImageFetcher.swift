import UIKit
import Foundation

struct ImageFetcher {

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

  static var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  static var imageAddresses = [String: NSURLSessionDataTask?]()

  // MARK: - Fetching

  static func fetch(URL: NSURL, imageAddress: String, completion: (result: Result) -> Void) {
    imageAddresses[imageAddress]??.cancel()

    imageAddresses[imageAddress] = session.dataTaskWithURL(URL) { data, response, error -> Void in
      if let error = error {
        complete(imageAddress) { completion(result: .Failure(error)) }
        return
      }

      guard let httpResponse = response as? NSHTTPURLResponse else {
        complete(imageAddress) { completion(result: .Failure(Error.InvalidResponse)) }
        return
      }

      guard httpResponse.statusCode == 200 else {
        complete(imageAddress) { completion(result: .Failure(Error.InvalidStatusCode)) }
        return
      }

      guard let data = data where httpResponse.validateLength(data) else {
        complete(imageAddress) { completion(result: .Failure(Error.InvalidStatusCode)) }
        return
      }

      guard let image = UIImage.decode(data) else {
        complete(imageAddress) { completion(result: .Failure(Error.ConvertionError)) }
        return
      }

      complete(imageAddress) { completion(result: Result.Success(image)) }
    }

    imageAddresses[imageAddress]??.resume()
  }

  static func complete(imageAddress: String, closure: () -> Void) {
    imageAddresses.removeValueForKey(imageAddress)

    dispatch_async(dispatch_get_main_queue()) {
      closure()
    }
  }
}
