// © GHOZT

/// An immutable object that holds a weak reference to a target object specified during
/// initialization. If the target object is a value type, it will be passed around as a value
/// regardless.
struct WeakReference<T: AnyObject> {

  weak var object: T?

  /// Creates a new `WeakReference` instance.
  ///
  /// - Parameter object: The target object to store as a weak reference. If the target object is a
  ///                     value type, it will be passed around as a value regardless.
  init(_ object: T) {
    self.object = object
  }

  /// Unwraps and returns the wrapped object. Since the object is weakly referenced, there is no
  /// guarantee that the object will still exist in memory when invoking this method (this does not
  /// apply if the wrapped object is a value type).
  ///
  /// - Returns: The wrapped object (if it still exists).
  public func get() -> T? { object}
}
