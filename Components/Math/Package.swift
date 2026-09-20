// swift-tools-version: 5.9

import PackageDescription

let version = "iosMath-2.5.0.1"
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
            checksum: "7df8ca162ecdfdedf2ee25e68b737ec9777b7a92aaa7a529fe856e1f12c9e55d"
        )
    ]
)
