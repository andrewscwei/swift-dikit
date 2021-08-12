// © Sybl

import Foundation

/// Injects the dependency into the wrapped property, assuming that the dependency was previously
/// registered with the `DependencyContainer`.
@propertyWrapper
public struct Inject<T> {

  private var value: T?
  private let tag: String

  public var wrappedValue: T {
    get { value ?? DependencyContainer.default.resolve(T.self, tag: tag) }
    set { value = newValue }
  }

  public init(_ tag: String = "") {
    self.tag = tag
  }
}
