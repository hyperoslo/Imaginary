import Cache

public var imageCache: Cache<UIImage> {
  struct Static {
    static let cache = Cache<UIImage>(name: "Imaginary")
  }

  return Static.cache
}
