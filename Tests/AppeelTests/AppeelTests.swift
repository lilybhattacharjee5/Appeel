import XCTest
@testable import Appeel

final class AppeelTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Appeel().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
