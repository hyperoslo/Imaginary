import Foundation

/// Process downloaded image
public protocol ImageProcessing {
  func process(image: Image) -> Image
}
