// This file contains a collection of type aliases to make
// the implementation more unified. Instead of referencing
// platform specific UI objects, we make type aliases to point
// to different implementations depending on the platform.

#if os(OSX)
  import Cocoa
  public typealias View = NSView
  public typealias Image = NSImage
  public typealias ImageView = NSImageView
  public typealias Button = NSButton
#else
  import UIKit
  public typealias View = UIView
  public typealias Image = UIImage
  public typealias ImageView = UIImageView
  public typealias Button = UIButton
#endif

public typealias Completion = (Result) -> Void
