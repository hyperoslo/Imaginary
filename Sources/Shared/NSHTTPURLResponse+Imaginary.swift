import Foundation

extension HTTPURLResponse {

  func validateLength(_ data: Data) -> Bool {
    return expectedContentLength > -1
      ? (Int64(data.count) >= expectedContentLength)
      : true
  }
}
