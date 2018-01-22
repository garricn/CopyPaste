//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class DeleteUITestCase: UITestCase {

    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launchArguments.append("resetData")
        app.launch()
    }

    func test_Swipe_To_Delete() {
        let app = XCUIApplication()
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.cells.staticTexts["This is just a test."].swipeLeft()
        app.tables.buttons["Delete"].tap()
        assertAppIsDisplayingAddItemCell()
    }

    func test_Edit_Button_Delete() {
        let app = XCUIApplication()
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Save"].tap()
        app.navigationBars["All Items"].buttons["Edit"].tap()

        let tables = app.tables
        tables.cells.buttons["Delete This is just a test., 0"].tap()
        tables.buttons["Delete"].tap()

        assertAppIsDisplayingAddItemCell()
    }

    func test_Delete_Multple_Items() {
        let app = XCUIApplication()
        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("Item 0")
        app.navigationBars["Add Item"].buttons["Save"].tap()

        app.navigationBars.buttons["Add Item"].tap()
        app.textViews["Body"].typeText("Item 1")
        app.navigationBars["Add Item"].buttons["Save"].tap()

        app.navigationBars["All Items"].buttons["Edit"].tap()

        let tables = app.tables
        tables.cells.buttons["Delete Item 0, 0"].tap()
        tables.buttons["Delete"].tap()

        tables.cells.buttons["Delete Item 1, 0"].tap()
        tables.buttons["Delete"].tap()

        assertAppIsDisplayingAddItemCell()
    }
}
