#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

public protocol ImageDrawer {
  func draw(_ image: Image, context: CGContext, rect: CGRect)
}
