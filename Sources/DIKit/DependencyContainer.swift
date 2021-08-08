// © Sybl

import Foundation

/// Singleton dependency injection container.
public class DependencyContainer {

  /// Factory method for creating instances of dependency `T`.
  public typealias Factory<T> = () -> T

  /// Returns the singleton `DependencyContainer` instance.
  public static let `default` = DependencyContainer()

  /// Private initializer to ensure singleton instance.
  private init() {}

  /// Dictionary of registered dependencies, where the key is the dependency type and the value is either a singleton
  /// instance of the dependency or a factory function of the dependency.
  private var dependencies: [String: Any] = [:]

  /// Registers a dependency as a singleton instance with the container.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for the same type).
  ///   - component: The singleton instance of the dependency to provide when resolving.
  public func register<T>(_ type: T.Type, tag: String = "", component: T) {
    let key = "\(type)@\(tag)"
    dependencies[key] = component
  }

  /// Registers a dependency as a factory function with the container.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for the same type).
  ///   - factory: The factory function.
  public func register<T>(_ type: T.Type, tag: String = "", factory: @escaping Factory<T>) {
    let key = "\(type)@\(tag)"
    dependencies[key] = factory
  }

  /// Unregisters a dependency from the container.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for the same type).
  public func unregister<T>(_ type: T.Type, tag: String = "") {
    let key = "\(type)@\(tag)"
    dependencies.removeValue(forKey: key)
  }

  /// Resolves a dependency and returns an instance of the dependency depndending on how it was registered. If it was
  /// registered as a singleton, the same instance of the dependency will always be returned. If it was registered as a
  /// factory function, a new instance of the dependency will be returned. Note that the app will terminate immediately
  /// if attempting to resolve an unregistered dependency.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for the same type).
  ///
  /// - Returns: An instance of the dependency.
  public func resolve<T>(_ type: T.Type = T.self, tag: String = "") -> T {
    let key = "\(T.self)@\(tag)"
    var component: T?

    if let factory = dependencies[key] as? Factory<T> {
      component = factory()
    }
    else if let singleton = dependencies[key] as? T {
      component = singleton
    }

    precondition(component != nil, "No dependency found for type \(key)")

    return component!
  }
}
