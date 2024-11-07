// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "DIKit",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "DIKit",
      targets: [
        "DIKit",
      ]
    ),
  ],
  targets: [
    .target(
      name: "DIKit",
      path: "Sources"
    ),
    .testTarget(
      name: "DIKitTests",
      dependencies: [
        "DIKit",
      ],
      path: "Tests"
    ),
  ]
)
