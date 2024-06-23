// swift-tools-version:5.3

import PackageDescription

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

enum Environment: String {
  case local
  case development
  case production

  static func get() -> Environment {
    if let envPointer = getenv("SWIFT_ENV"), let environment = Environment(rawValue: String(cString: envPointer)) {
      return environment
    }
    else if let envPointer = getenv("CI"), String(cString: envPointer) == "true" {
      return .production
    }
    else {
      return .local
    }
  }
}

switch Environment.get() {
case .local:
  break
case .development:
  break
case .production:
  break
}

let package = Package(
  name: "DIKit",
  platforms: [.iOS(.v11)],
  products: [
    .library(
      name: "DIKit",
      targets: ["DIKit"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "DIKit"
    ),
    .testTarget(
      name: "DIKitTests",
      dependencies: ["DIKit"]
    )
  ]
)
