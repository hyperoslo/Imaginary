# Imaginary

[![CI Status](http://img.shields.io/travis/hyperoslo/Imaginary.svg?style=flat)](https://travis-ci.org/hyperoslo/Imaginary)
[![Version](https://img.shields.io/cocoapods/v/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![License](https://img.shields.io/cocoapods/l/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![Platform](https://img.shields.io/cocoapods/p/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
![Swift](https://img.shields.io/badge/%20in-swift%202.2-orange.svg)

<img src="https://raw.githubusercontent.com/hyperoslo/Imaginary/master/Images/icon.png" alt="Brick Icon" align="right" />

## Description

Using remote images in an application is more or less a requirement these days.
That process should be hassle free and with `Imaginar`, it is.
With a narrow yet flexible public API, you can set images using URL's, add
placeholdes, pre-process images and use callbacks for when images are set.

## Usage

### Set image with URL
```swift
let imageView: UIImageView()
let imageURL: NSURL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")
imageView.setImage(URL: imageURL)
```

### How to apply placeholder images
```swift
let imageView: UIImageView()
let placeholder = UIImage(named: "PlaceholderImage")
let imageURL: NSURL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")
imageView.setImage(URL: imageURL, placeholder: placeholder)
```

### Pre-processing images
```swift
let imageView: UIImageView()
let imageURL: NSURL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")
imageView.setImage(URL: imageURL, preprocess: { image in
  /// Apply pre-process here ...
  return image
})
```

### Callback when image is set to the image view
```swift
let imageView: UIImageView()
let imageURL: NSURL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")
imageView.setImage(URL: imageURL) { image in
  /// This closure gets called when the image is set to the image view.
}
```

## Installation

**Imaginary** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Imaginary'
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**Imaginary** is available under the MIT license. See the LICENSE file for more info.
