//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

extension XCTestCase {

    func assertApp(isDisplaying element: XCUIElement, within timeout: TimeInterval = 2.0, file: String = #file, line: UInt = #line) {
        waitForAppearance(of: element, timeout: timeout, file: file, line: line)
        XCTAssert(element.exists)
    }

    func waitForAppearance(of element: XCUIElement, timeout: TimeInterval, file: String, line: UInt) {
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { error in
            if error != nil {
                let description = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: description, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}
