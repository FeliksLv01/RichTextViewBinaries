// swift-tools-version: 5.9

import PackageDescription

let version = "iosMath-2.5.0.2"
let releaseBaseURL = "https://github.com/FeliksLv01/RichTextViewBinaries/releases/download/\(version)"

let package = Package(
    name: "RichTextViewMathBinary",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "RichTextViewMathBinary", targets: ["iosMath"])
    ],
    targets: [
        .binaryTarget(
            name: "iosMath",
            url: "\(releaseBaseURL)/iosMath.xcframework.zip",
            checksum: "c7850946f56d479fd3bb0ec0842d1ed3622b26927d8f1016f950e9ccd2a271c7"
        )
    ]
)
