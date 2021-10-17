import XCTest
@testable import DIKit

class DependencyInjectionTests: XCTestCase {

  func testDependencies() {
    let container = DependencyContainer.default
    XCTAssertNotNil(container)

    class Foo {}

    container.register(Foo.self) { Foo() }

    let foo1 = container.resolve(Foo.self)
    let foo2 = container.resolve(Foo.self)

    XCTAssertTrue(foo1 === foo2)
  }

  func testTaggedDependencies() {
    let container = DependencyContainer.default
    XCTAssertNotNil(container)

    class Foo {}

    container.register(tag: "1") { Foo() }
    container.register(tag: "2") { Foo() }

    let foo1 = container.resolve(Foo.self, tag: "1")
    let foo2 = container.resolve(Foo.self, tag: "2")

    XCTAssertTrue(foo1 !== foo2)
  }

  func testScopedDependencies() {
    let container = DependencyContainer.default
    XCTAssertNotNil(container)

    class Foo {}

    container.register { Foo() }

    let foo1 = container.resolve(Foo.self, scope: "1")
    let foo2 = container.resolve(Foo.self, scope: "2")

    XCTAssertTrue(foo1 !== foo2)
  }

  func testInjection() {
    let container = DependencyContainer.default
    XCTAssertNotNil(container)

    class Foo {}

    container.register(Foo.self) { Foo() }

    class Bar {
      @Inject var foo: Foo
    }

    let bar = Bar()

    XCTAssertNotNil(bar.foo)
  }
}
