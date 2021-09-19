// © Sybl

import BaseKit
import Foundation

/// Singleton dependency injection container.
public class DependencyContainer {

  /// Factory method for creating instances of dependency `T`.
  public typealias Factory<T> = () -> T

  /// Returns the singleton `DependencyContainer` instance.
  public static let `default` = DependencyContainer()

  /// Private initializer to ensure singleton instance.
  private init() {}

  /// Dictionary of factory methods for registered dependencies, where the key made up of the
  /// dependency type plus its associated tag at the time of registration.
  private var factories: [String: Factory<Any>] = [:]

  /// Dictionary of instantiated dependencies, where the key is made up of the dependency type. its
  /// associated tag at the time of registration, and its scope at the time of resolution.
  private var dependencies: [String: WeakReference<Any>] = [:]

  /// Registers a dependency with the container. The dependency is instantiated at resolve time.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for
  ///          the same type).
  ///   - factory: The factory function.
  public func register<T>(_ type: T.Type = T.self, tag: String? = nil, factory: @escaping Factory<T>) {
    let key = generateKey(for: type, tag: tag, scope: nil)
    factories[key] = factory
  }

  /// Unregisters a dependency from the container.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for
  ///          the same type).
  public func unregister<T>(_ type: T.Type = T.self, tag: String = "") {
    let key = generateKey(for: type, tag: tag, scope: nil)
    factories.removeValue(forKey: key)
  }

  /// Resolves a dependency and returns an instance of the dependency matching its registered tag.
  /// Option to specify a scope, which if left unspecified as `nil`, will assume the global scope.
  /// When resolving this dependency, the same instance matching this scope name will always be
  /// returned. If an instance is not found, it will be instantiated using the registered factory.
  /// Note that the app will terminate immediately if attempting to resolve an unregistered
  /// dependency (the type and tag must match).
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different implementations for
  ///          the same type).
  ///   - scope: An optional scope name for the dependency.
  ///
  /// - Returns: An instance of the dependency.
  public func resolve<T>(_ type: T.Type = T.self, tag: String? = nil, scope: String? = nil) -> T {
    let factoryKey = generateKey(for: T.self, tag: tag, scope: nil)
    let instanceKey = generateKey(for: T.self, tag: tag, scope: scope)

    if let component = dependencies[instanceKey]?.get() as? T {
      return component
    }
    else if let factory = factories[factoryKey], let component = factory() as? T {
      dependencies[instanceKey] = WeakReference(component)
      return component
    }
    else {
      fatalError("No dependency found for type \"\(T.self)\", tag \"\(String(describing: tag))\" in scope \"\(String(describing: scope))\"")
    }
  }

  /// Generates a hash key for the dependency type with the specified tag and scope.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type.
  ///   - scope: The name of the scope to bind the dependency to.
  private func generateKey<T>(for type: T.Type, tag: String?, scope: String?) -> String {
    var prefix: String = ""
    var suffix: String = ""

    if let scope = scope { prefix = "\(scope)/" }
    if let tag = tag { suffix = "@\(tag)" }

    return "\(prefix)\(T.self)\(suffix)"
  }
}
