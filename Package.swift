// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Imaginary",
    products: [
        .library(
            name: "Imaginary",
            targets: ["Imaginary"]),
    ],
    dependencies: [
      .package(path: "/Users/kristaps/Documents/open-source/Cache")
    ],
    targets: [
        .target(
            name: "Imaginary",
            dependencies: ["Cache"],
            path: "Sources"
            )
    ],
    swiftLanguageVersions: [.v5]
)
