import Foundation

#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

public protocol ImageDrawer {
  func draw(image: Image, context: CGContext, rect: CGRect)
}
