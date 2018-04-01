//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class SessionBaseUITestCase: UITestCase {

    override func setUp() {
        super.setUp()
        app.launchEnvironment[Globals.EnvironmentVariables.showWelcome] = "false"
    }
}

final class DeleteUITestCase: SessionBaseUITestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    override func tearDown() {
        UITestHelper.debugPerform(resetAction: .data, application: XCUIApplication())
        super.tearDown()
    }

    func test_Swipe_To_Delete() {
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.cells.staticTexts["This is just a test."].swipeLeft()
        app.tables.buttons["Delete"].tap()
        assertAppIsDisplayingAddItemCell()
    }

    func test_Edit_Button_Delete() {
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.navigationBars["All Items"].buttons["Edit"].tap()

        let tables = app.tables
        tables.cells.buttons["Delete This is just a test."].tap()
        tables.buttons["Delete"].tap()

        assertAppIsDisplayingAddItemCell()
    }

    func test_Delete_Multple_Items() {
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("Item 0")
        app.navigationBars["Add Item"].buttons["Save"].tap()

        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("Item 1")
        app.navigationBars["Add Item"].buttons["Save"].tap()

        app.navigationBars["All Items"].buttons["Edit"].tap()

        let tables = app.tables
        tables.cells.buttons["Delete Item 0"].tap()
        tables.buttons["Delete"].tap()

        tables.cells.buttons["Delete Item 1"].tap()
        tables.buttons["Delete"].tap()

        assertAppIsDisplayingAddItemCell()
    }
}
