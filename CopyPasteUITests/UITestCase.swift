//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launchArguments.append("isUITesting")
    }

    func assertAppIsDisplayingAllItems() {
        let app = XCUIApplication()
        let element = app.navigationBars["All Items"]
        assertApp(isDisplaying: element)
    }

    func assertAppIsDisplayingAddItemCell() {
        let element = XCUIApplication().cells.staticTexts["Add Item"]
        assertApp(isDisplaying: element)
    }
}
