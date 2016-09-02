import Foundation

#if os(OSX)
  import Cocoa
  public typealias Image = NSImage
#else
  import UIKit
  public typealias Image = UIImage
#endif
