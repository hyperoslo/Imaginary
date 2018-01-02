# Imaginary

[![CI Status](https://circleci.com/gh/hyperoslo/Imaginary.png)](https://circleci.com/gh/hyperoslo/Imaginary)
[![Version](https://img.shields.io/cocoapods/v/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![License](https://img.shields.io/cocoapods/l/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
[![Platform](https://img.shields.io/cocoapods/p/Imaginary.svg?style=flat)](http://cocoadocs.org/docsets/Imaginary)
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

<img src="https://raw.githubusercontent.com/hyperoslo/Imaginary/master/Images/icon.png" alt="Brick Icon" align="right" />

## Table of Contents

- [Description](#description)
- [Usage](#usage)
  - [Basic](#basic)
  - [Advanced](#advanced)
  - [Configuration](#configuration)
  - [ImageFetcher](#imagefetcher)
- [Installation](#installation)

## Description

Using remote images in an application is more or less a requirement these days.
This process should be easy, straight-forward and hassle free, and with
`Imaginary`, it is. The library comes with a narrow yet flexible public API and
a bunch of built-in unicorny features:

- [x] Asynchronous image downloading
- [x] Memory and disk cache based on [Cache](https://github.com/hyperoslo/Cache)
- [x] Image decompression
- [x] Default transition animations
- [x] Possibility to pre-process and modify the original image
- [x] Works on any view, including `ImageView`, `Button`, ...
- [x] Supports iOS, tvOS, macOS

## Usage

In the most common case, you want to set remote image from url onto `ImageView`. `Imaginary` does the heavy job of downloading and caching images. The caching is done via 2 cache layers (memory and disk) to allow fast retrieval. It also manages expiry for you. And the good news is that you can customise most of these features.

## Basic

#### Set image with URL

Simply pass `URL` to fetch.

```swift
let imageUrl = URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")
imageView.setImage(url: imageUrl)
```

#### Use placeholder

Placeholder is optional. But the users would be much pleased if they see something while images are being fetched.

```swift
let placeholder = UIImage(named: "PlaceholderImage")
let imageUrl = URL(string: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200")

imageView.setImage(url: imageUrl, placeholder: placeholder)
```

#### Use callback for when the image is fetched

If you want to get more info on the fetching result, you can pass a closure as `completion`.

```swift
imageView.setImage(url: imageUrl) { result in
  switch result {
  case .value(let image):
    print(image)
  case .error(let error):
    print(error)
  }
}
```

`result` is an enum `Result` that let you know if the operation succeeded or failed. The possible error is of `ImaginaryError`.

## Advanced

### Passing option

You can also pass `Option` when fetching images; it allows fine grain control over the fetching process. `Option` defaults to no pre-processor and a displayer for `ImageView`.

```
let option = Option()
imageView.setImage(url: imageUrl, option: option)
```

### Pre-processing

Images are fetched, decompressed and pre-processed in the background. If you want to modify, simply implement your own `ImageProcessor` and specify it in the `Option`. The pre-processing is done in the background, before the image is set into view.

```swift
public protocol ImageProcessor {
  func process(image: Image) -> Image
}
```

This is how you apply tint color before setting images.


```swift
let option = Option(imagePreprocessor: TintImageProcessor(tintColor: .orange))
imageView.setImage(url: imageUrl, option: option)
```

`Imaginary` provides the following built in pre-processors

- [x] `TintImageProcessor`: apply tint color using color blend effect
- [ ] `ResizeImageProcessor`: resize
- [ ] `RoundImageProcessor`: make round corner

### Displaying

`Imaginary` supports any `View`, it can be `UIImageView`, `UIButton`, `MKAnnotationView`, `UINavigationBar`, ... As you can see, the fetching is the same, the difference is the way the image is displayed. To avoid code duplication, `Imaginary` take advantages of Swift protocols to allow fully customisation.

You can roll out your own `displayer` by comforming to `ImageDisplayer` and specify that in `Option`

```swift
public protocol ImageDisplayer {
  func display(placeholder: Image, onto view: View)
  func display(image: Image, onto view: View)
}
```

This is how you set an image for `UIButton`

```swift
let option = Option(imageDisplayer: ButtonDisplayer())
button.setImage(url: imageUrl, option: option)

let option = Option(imageDisplayer: ImageDisplayer(animationOption: .transitionCurlUp))
imageView.setImage(url: imageUrl, option: option)
```

These are the buit in displayers. You need to supply the correct displayer for your view

- [x] ImageDisplayer: display onto `UI|NSImageView`. This is the default with cross dissolve animation.
- [x] ButtonDisplayer: display onto `UI|NSButton` using `setImage(_ image: UIImage?, for state: UIControlState)`
- [x] ButtonBackgroundDisplayer: display onto `UI|NSButton` using `setBackgroundImage(_ image: UIImage?, for state: UIControlState)`

### Downloading

`Imaginary` uses `ImageFetcher` under the hood, which has downloader and storage.  You can specify your own `ImageDownloader` together with a `modifyRequest` closure, there you can change request body or add more HTTP headers.

```swift
var option = Option()
option.downloaderMaker = {
  return ImageDownloader(modifyRequest: { 
    var request = $0
    request.addValue("Bearer 123", forHTTPHeaderField: "Authorization")
    return request 
  })
}

imageView.setImage(imageUrl, option: option)
```

### Caching

The storage defaults to `Configuration.storage`, but you can use your own `Storage`, this allows you to group saved images for particular feature. What if you want forced downloading and ignore storage? Then simply return `nil`. For how to configure `storage`, see [Storage](https://github.com/hyperoslo/Cache#storage)

```swift
var option = Option()
option.storageMaker = {
  return Configuration.imageStorage
}
```

## Configuration

You can customise the overal experience with `Imaginary` through `Configuration`.

- `trackBytesDownloaded`: track how many bytes have been used to download a specific image
- `trackError`: track if any error occured when fetching an image.
- `imageStorage`: the storage used by all fetching operations.

## ImageFetcher

`Imaginary` uses `ImageFetcher` under the hood. But you can use it as a standalone component.

### ImageDownloader

Its main task is to download image and perform all kinds of sanity checkings.

```swift
let downloader = ImageDownloader()
downloader.download(url: imageUrl) { result in
  // handle result
}
```

### ImageFetcher

This knows how to fetch and cache the images. It first checks memory and disk cache to see if there's image. If there isn't it will perform network download. You can optionally ignore the cache by setting storage to `nil`.

```swift
let fetcher = ImageFetcher(downloader: ImageDownloader(), storage: myStorage()
fetcher.fetch(url: imageUrl) { result in
  // handle result
}
```

### MultipleImageFetcher

It sometimes makes sense to pre download images beforehand to improve user experience. We have `MultipleImageFetcher` for you

```swift
let multipleFetcher = MultipleImageFetcher(fetcherMaker: {
  return ImageFetcher()
})

multipleFetcher.fetch(urls: imageUrls, each: { result in
  // handle when each image is fetched
}, completion: {
  // handle when all images are fetched
})
```

This is ideal for the new [prefetching mode in UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/1771771-prefetchingenabled)


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
