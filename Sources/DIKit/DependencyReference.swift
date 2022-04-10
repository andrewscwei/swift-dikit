// © GHOZT

struct DependencyReference<T: AnyObject> {

  weak var dependency: T?

  init(_ dependency: T) {
    self.dependency = dependency
  }

  public func get() -> T? { dependency }
}
