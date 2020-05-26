import XCTest
@testable import menu_core

final class menu_coreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(menu_core().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
