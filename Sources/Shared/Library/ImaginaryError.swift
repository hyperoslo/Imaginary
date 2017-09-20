import Foundation

/// Error
public enum ImaginaryError: Error {
  case invalidResponse
  case invalidStatusCode
  case invalidData
  case invalidContentLength
  case conversionError
}
