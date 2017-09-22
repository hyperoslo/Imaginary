import AppKit

/// Used to set image onto ImageView
public class ImageViewDisplayer: ImageDisplayer {
  public func display(placeholder: Image, onto view: View) {
    guard let imageView = view as? ImageView else {
      return
    }

    imageView.image = placeholder
  }

  public func display(image: Image, onto view: View) {
    guard let imageView = view as? ImageView else {
      return
    }

    guard let oldImage = imageView.image,
      imageView.window?.inLiveResize == false else {
      imageView.image = image
      return
    }

    let animation = CABasicAnimation(keyPath: "contents")
    animation.duration = 0.25
    animation.fromValue = oldImage.cgImage
    animation.toValue = image.cgImage
    imageView.wantsLayer = true
    imageView.layer?.add(animation, forKey: "transitionAnimation")
    imageView.image = image
  }

  public init() {}
}

fileprivate extension NSImage {
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
