import Cocoa

extension NSImage {

  var cgImage: CGImage? {
    guard let data = TIFFRepresentation,
      source = CGImageSourceCreateWithData(data, nil),
      maskRef = CGImageSourceCreateImageAtIndex(source, 0, nil)
      else {
        return nil
    }

    return maskRef
  }

}
