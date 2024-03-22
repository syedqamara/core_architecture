import XCTest
@testable import Core

final class CoreTests: XCTestCase {
    
    func testExample() throws {
        enum LogingAction: String, LogAction {
            case log
        }
        let logger = Logs<LogingAction>(id: "123")
        logger.trackLog(type: .warning(configID: "1122"), ["example_JSON_key": "Json Object"], action: .log)
        logger.log(log: .warning(configID: "1122"))
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Core().text, "Hello, World!")
    }
}
