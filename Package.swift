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
        .package(url: "https://github.com/hyperoslo/Cache", .exactItem("6.0.0"))
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
