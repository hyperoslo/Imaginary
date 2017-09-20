import CoreGraphics

public protocol ImageDrawer {
  func draw(_ image: Image, context: CGContext, rect: CGRect)
}
