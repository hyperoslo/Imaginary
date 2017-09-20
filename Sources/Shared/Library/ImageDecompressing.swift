import Foundation

/// Decompress downloaded data
protocol ImageDecompressing {
  func decompress(data: Data) -> Image?
}
