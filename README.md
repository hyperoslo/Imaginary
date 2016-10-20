# Imaginary

[![CI Status](http://img.shields.io/travis/hyperoslo/Imaginary.svg?style=flat)](https://travis-ci.org/hyperoslo/Imaginary)
[![Version](https://img.shields.io/cocoapods/v/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![License](https://img.shields.io/cocoapods/l/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![Platform](https://img.shields.io/cocoapods/p/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)

<img src="https://raw.githubusercontent.com/hyperoslo/Imaginary/master/Images/icon.png" alt="Brick Icon" align="right" />

## Description

Using remote images in an application is more or less a requirement these days.
This process should be easy, straight-forward and hassle free, and with
`Imaginary`, it is. The library comes with a narrow yet flexible public API and
a bunch of built-in unicorny features:

- [x] Asynchronous image downloading
- [x] Memory and disk [cache](https://github.com/hyperoslo/Cache)
- [x] Image decompression
- [x] Default transition animations
- [x] Possibility to pre-process and modify the original image

## Regular usage

### Set image with URL

```swift
let imageView: UIImageView()
let imageUrl: URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")

imageView.setImage(url: imageUrl)
```

### Apply placeholder images

```swift
let imageView: UIImageView()
let placeholder = UIImage(named: "PlaceholderImage")
let imageUrl: URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")

imageView.setImage(url: imageUrl, placeholder: placeholder)
```

### Use callback for when the image is set to the image view
```swift
let imageView: UIImageView()
let imageUrl: URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")

imageView.setImage(url: imageUrl) { image in
  /// This closure gets called when the image is set to the image view.
}
```

## Advanced usage

### Images pre-processing

`preprocess` closure is a good place to modify the original image before
it's being cached and displayed on the screen.

```swift
let imageView: UIImageView()
let imageUrl: URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")

imageView.setImage(url: imageUrl, preprocess: { image in
  /// Apply pre-process here ...
  let effect = TintDrawer(tintColor: UIColor.blue)
  return image.modify(with: effect) ?? image
})
```

`TintDrawer`, which comes together with **Imaginary**, is an implementation of
the color blend effect. For the time being it's the only built-in
"preprocessor", but you have all the power in your hands to do apply custom
filters and transformations to make the image shine.

### Transition animations

If you're not satisfied with default transition animations there is always a
chance to improve or even disable them:

```swift
Imaginary.preConfigure = { imageView in
  // Prepare the image view before the image is fetched.
}

Imaginary.transitionClosure = { imageView, newImage in
  // Transition animations go here.
}

Imaginary.postConfigure = { imageView in
  // Setup the image view when the image is set.
}
```

### Cache

**Imaginary** uses [Cache](https://github.com/hyperoslo/Cache) under the hood
to store images in memory and on the disk. It's possible to change the default
`Cache<Image>` instance and use your custom configured cache:

```swift
Imaginary.Configuration.imageCache = Cache<Image>(
  name: "Imaginary",
  config: customConfig
)
```

Read more about cache configuration [here](https://github.com/hyperoslo/Cache#hybrid-cache)

## Installation

**Imaginary** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Imaginary'
```

**Imaginary** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "hyperoslo/Imaginary"
```

**Imaginary** can also be installed manually. Just download and drop `Sources`
folders in your project.

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**Imaginary** is available under the MIT license. See the LICENSE file for more info.
