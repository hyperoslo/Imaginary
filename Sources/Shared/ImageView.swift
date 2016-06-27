import Foundation

#if os(OSX)
  import Cocoa
  public typealias ImageView = NSImageView
#else
  import UIKit
  public typealias ImageView = UIImageView
#endif
