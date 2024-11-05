public struct DependencyReference<T> {
  private let getDependency: () -> T?

  public init(_ dependency: T) {
    let reference = dependency as AnyObject

    getDependency = { [weak reference] in
      reference as? T
    }
  }

  public func get() -> T? { getDependency() }
}
