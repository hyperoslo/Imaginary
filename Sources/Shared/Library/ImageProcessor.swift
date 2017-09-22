import Foundation

/// Process downloaded image
public protocol ImageProcessor {
  func process(image: Image) -> Image
}
