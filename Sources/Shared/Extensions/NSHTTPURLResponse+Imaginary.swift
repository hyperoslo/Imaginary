import Foundation

extension NSHTTPURLResponse {

  func validateLength(data: NSData) -> Bool {
    return expectedContentLength > -1
      ? (Int64(data.length) >= expectedContentLength)
      : true
  }
}
