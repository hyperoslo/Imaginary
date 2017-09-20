import Foundation

/// Error
public enum ImaginaryError: Error {
  case deallocated
  case invalidResponse
  case invalidStatusCode
  case invalidData
  case invalidContentLength
  case conversionError
}
