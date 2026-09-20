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
            checksum: "71b31789af1911f47e820d0c00367bf98837ce462217a93c5a07b7ecaa49a260"
        )
    ]
)
