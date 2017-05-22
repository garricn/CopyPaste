//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class EditUITestCase: UITestCase {

    func test_Edit_Canceled_With_No_Changes() {
        addItemBarButton.tap()
        app.textViews["Body"].typeText("This is just a test.")
        navigationBars["Add Item"].buttons["Save"].tap()

        app.cells["This is just a test."].press(forDuration: 1.0)
        navigationBars["Edit Item"].buttons["Cancel"].tap()

        assertApp(isDisplaying: app.cells["This is just a test."])
    }

    func test_Edit_Canceled_With_Changes() {
        addItemBarButton.tap()
        app.textViews["Body"].typeText("This is just a test.")
        navigationBars["Add Item"].buttons["Save"].tap()

        app.cells["This is just a test."].press(forDuration: 1.0)
        app.keys["delete"].press(forDuration: 1.0)
        navigationBars["Edit Item"].buttons["Cancel"].tap()

        assertApp(isDisplaying: app.cells["This is just a test."])
    }

    func test_Edit_Saved_With_No_Changes() {
        addItemBarButton.tap()
        app.textViews["Body"].typeText("This is just a test.")
        navigationBars["Add Item"].buttons["Save"].tap()

        app.cells["This is just a test."].press(forDuration: 1.0)
        navigationBars["Edit Item"].buttons["Save"].tap()

        assertApp(isDisplaying: app.cells["This is just a test."])
    }

    func test_Edit_Saved_With_Changes() {
        addItemBarButton.tap()
        app.textViews["Body"].typeText("This is just a test.")
        navigationBars["Add Item"].buttons["Save"].tap()

        app.cells["This is just a test."].press(forDuration: 1.0)
        app.textViews["Body"].typeText(" Ok?")
        navigationBars["Edit Item"].buttons["Save"].tap()

        assertApp(isDisplaying: app.cells["This is just a test. Ok?"])
    }
}
