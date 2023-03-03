// © GHOZT

import Foundation

/// Singleton dependency injection container.
public class DependencyContainer {

  /// Factory method for creating instances of dependency `T`.
  public typealias Factory<T> = () -> T

  /// Returns the singleton `DependencyContainer` instance.
  public static let `default` = DependencyContainer()

  /// Private initializer to ensure singleton instance.
  private init() {}

  /// Lock queue for thread-safe read/write access to dependency and factory dictionary.
  private let lockQueue = DispatchQueue(label: "io.ghozt.dikit.DependencyContainer.lock-queue", qos: .default, attributes: .concurrent)

  /// Dictionary of factory methods for registered dependencies, where the key
  /// made up of the dependency type plus its associated tag at the time of
  /// registration.
  private var factories: [String: Factory<Any>] = [:]

  /// Dictionary of instantiated dependencies, where the key is made up of the
  /// dependency type. its associated tag at the time of registration, and its
  /// scope at the time of resolution.
  private var dependencies: [String: DependencyReference<Any>] = [:]

  /// Registers a dependency with the container. The dependency is instantiated
  /// at resolve time.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different
  ///          implementations for the same type).
  ///   - factory: The factory function.
  public func register<T>(_ type: T.Type = T.self, tag: String? = nil, factory: @escaping Factory<T>) {
    let key = generateKey(for: type, tag: tag, scope: nil)
    addDependencyFactory(factory, forKey: key)
  }

  /// Unregisters a dependency from the container.
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different
  ///          implementations for the same type).
  public func unregister<T>(_ type: T.Type = T.self, tag: String = "") {
    let key = generateKey(for: type, tag: tag, scope: nil)
    removeDependencyFactory(forKey: key)
  }

  /// Resolves a dependency and returns an instance of the dependency matching
  /// its registered tag. Option to specify a scope, which if left unspecified
  /// as `nil`, will assume the global scope. When resolving this dependency,
  /// the same instance matching this scope name will always be returned. If an
  /// instance is not found, it will be instantiated using the registered
  /// factory. Note that the app will terminate immediately if attempting to
  /// resolve an unregistered dependency (the type and tag must match).
  ///
  /// - Parameters:
  ///   - type: The type of the dependency.
  ///   - tag: A tag to associate with the type (to allow providing different
  ///          implementations for the same type).
  ///   - scope: An optional scope name for the dependency.
  ///
  /// - Returns: An instance of the dependency.
  public func resolve<T>(_ type: T.Type = T.self, tag: String? = nil, scope: String? = nil) -> T {
    let factoryKey = generateKey(for: T.self, tag: tag, scope: nil)
    let dependencyKey = generateKey(for: T.self, tag: tag, scope: scope)

    if let component: T = getDependency(forKey: dependencyKey) {
      return component
    }
    else if let factory = getDependencyFactory(forKey: factoryKey), let dependency = factory() as? T {
      addDependency(dependency, forKey: dependencyKey)
      return dependency
    }
    else {
      fatalError("No dependency found for type \"\(T.self)\", tag \"\(String(describing: tag))\" in scope \"\(String(describing: scope))\"")
    }
  }

  /// Returns the factory method of a dependency type.
  ///
  /// - Parameters:
  ///   - key: The key of the registered factory.
  ///
  /// - Returns: The factory method if it exists.
  private func getDependencyFactory(forKey key: String) -> Factory<Any>? {
    lockQueue.sync {
      factories[key]
    }
  }

  /// Adds a factory method for a dependency type at the specified key.
  ///
  /// - Parameters:
  ///   - factory: The factory method.
  ///   - key: The key for future reference.
  private func addDependencyFactory<T>(_ factory: @escaping Factory<T>, forKey key: String) {
    lockQueue.async(flags: .barrier) {
      self.factories[key] = factory
    }
  }

  /// Removes the factory method for the specified key.
  ///
  /// - Parameters:
  ///   - key: The key.
  private func removeDependencyFactory(forKey key: String) {
    lockQueue.async(flags: .barrier) {
      self.factories.removeValue(forKey: key)
    }
  }

  /// Returns the instance of a dependency type registered at the specified key.
  ///
  /// - Returns: The dependency instance if it exists.
  private func getDependency<T>(forKey key: String) -> T? {
    lockQueue.sync {
      dependencies[key]?.get() as? T
    }
  }

  /// Adds an instance for a dependency type at the specified key.
  ///
  /// - Parameters:
  ///   - dependency: The dependency instance.
  ///   - key: The key for future reference.
  private func addDependency<T>(_ dependency: T, forKey key: String) {
    lockQueue.async(flags: .barrier) {
      self.dependencies[key] = DependencyReference(dependency)
    }
  }

  /// Removes the dependency instance for the specified key.
  ///
  /// - Parameters:
  ///   - key: The key.
  private func removeDependency(forKey key: String) {
    lockQueue.async(flags: .barrier) {
      self.dependencies.removeValue(forKey: key)
    }
  }

  /// Generates a hash key for the dependency type with the specified tag and
  /// scope.
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
