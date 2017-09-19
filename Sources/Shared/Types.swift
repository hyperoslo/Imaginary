// This file contains a collection of type aliases to make
// the implementation more unified. Instead of referencing
// platform specific UI objects, we make type aliases to point
// to different implementations depending on the platform.

#if os(OSX)
  import Cocoa
  public typealias Image = NSImage
  public typealias ImageView = NSImageView
#else
  import UIKit
  public typealias Image = UIImage
  public typealias ImageView = UIImageView
#endif

/// Result for fetching
public enum Result {
  case value(Image)
  case error(Error)
}

public typealias Preprocess = (Image) -> Image
public typealias Completion = (Result) -> Void
