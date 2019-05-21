import XCTest
@testable import Expressions

final class ExpressionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Expressions().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
