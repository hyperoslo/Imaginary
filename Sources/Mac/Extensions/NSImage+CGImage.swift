import Cocoa

extension NSImage {

  var cgImage: CGImage? {
    guard let data = tiffRepresentation,
      let source = CGImageSourceCreateWithData(data as CFData, nil),
      let maskRef = CGImageSourceCreateImageAtIndex(source, 0, nil)
      else {
        return nil
    }

    return maskRef
  }

}
