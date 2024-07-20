import XCTest
@testable import ImperialCore

class ImperialTests: XCTestCase {
    func testExists() {}
    
    func testPathComponents() {
        let callback = "http://localhost:8080/A/B/C"
        XCTAssertEqual(callback.pathComponents(grouped: [":A"]).map{$0.description}.joined(), "ABC")
        XCTAssertEqual(callback.pathComponents(grouped: ["*"]).map{$0.description}.joined(), "ABC")
        XCTAssertEqual(callback.pathComponents(grouped: ["A"]).map{$0.description}.joined(), "BC")
        XCTAssertEqual(callback.pathComponents(grouped: ["A", "B"]).map{$0.description}.joined(), "C")
        XCTAssertEqual(callback.pathComponents(grouped: ["A", "B", "C"]).map{$0.description}.joined(), "")
        XCTAssertEqual(callback.pathComponents(grouped: ["A", "B", "C", "D"]).map{$0.description}.joined(), "")
        XCTAssertEqual(callback.pathComponents(grouped: ["A", "B", "X"]).map{$0.description}.joined(), "C")
        XCTAssertEqual(callback.pathComponents(grouped: ["X", "B", "C"]).map{$0.description}.joined(), "ABC")
        XCTAssertEqual(callback.pathComponents(grouped: ["A", "X", "C"]).map{$0.description}.joined(), "BC")
        XCTAssertEqual(callback.pathComponents(grouped: []).map{$0.description}.joined(), "ABC")
    }
    
    static var allTests: [(String, (ImperialTests) -> () -> ())] = [
        ("testExists", testExists),
        ("testPathComponents", testPathComponents),
    ]
}
