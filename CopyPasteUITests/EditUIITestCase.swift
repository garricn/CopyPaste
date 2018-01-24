//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class EditUITestCase: SessionBaseUITestCase {

    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }

    override func tearDown() {
        UITestHelper.debugPerform(resetAction: .data, application: XCUIApplication())
        super.tearDown()
    }

    func test_Edit_Canceled_With_No_Changes() {
        
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.tables.buttons["More Info, This is just a test., 0"].tap()
        app.navigationBars["Edit Item"].buttons["Cancel"].tap()
        assertApp(isDisplaying: app.tables.staticTexts["This is just a test."])
    }

    func test_Edit_Canceled_With_Changes() {
        
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.tables.buttons["More Info, This is just a test., 0"].tap()
        app.textViews["Body"].typeText(" Ok?")
        app.navigationBars["Edit Item"].buttons["Cancel"].tap()
        assertApp(isDisplaying: app.tables.staticTexts["This is just a test."])
    }

    func test_Edit_Saved_With_No_Changes() {
        
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.tables.buttons["More Info, This is just a test., 0"].tap()
        app.navigationBars["Edit Item"].buttons["Save"].tap()
        assertApp(isDisplaying: app.tables.staticTexts["This is just a test."])
    }

    func test_Edit_Saved_With_Changes() {
        
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.tables.buttons["More Info, This is just a test., 0"].tap()
        app.textViews["Body"].typeText(" Ok?")
        app.navigationBars["Edit Item"].buttons["Save"].tap()
        assertApp(isDisplaying: app.tables.staticTexts["This is just a test. Ok?"])
    }
}
