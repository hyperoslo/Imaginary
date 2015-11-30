import Foundation

public class ImageFetcher {

  public enum Error {
    case InvalidData
    case MissingData
    case InvalidStatusCode
  }

  public let URL: NSURL
  var task: NSURLSessionDataTask?

  public var session: NSURLSession {
    return NSURLSession.sharedSession()
  }

  public init(URL: NSURL) {
    self.URL = URL
  }
}
