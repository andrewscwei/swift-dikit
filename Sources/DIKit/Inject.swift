// © Sybl

import Foundation

/// Injects the dependency into the wrapped property, assuming that the dependency was previously
/// registered with the `DependencyContainer`.
@propertyWrapper
public struct Inject<T> {

  private var value: T?
  private let tag: String

  public var wrappedValue: T {
    mutating get {
      if let dependency = value {
        return dependency
      }
      else {
        let dependency = DependencyContainer.default.resolve(T.self, tag: tag)
        value = dependency
        return dependency
      }
    }

    set {
      value = newValue
    }
  }

  public init(_ tag: String = "") {
    self.tag = tag
  }
}
