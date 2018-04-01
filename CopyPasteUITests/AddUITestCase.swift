//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class AddUITestCase: SessionBaseUITestCase {

    private var item0: XCUIElement {
        return app.tables.cells.staticTexts["This is just a test."]
    }

    override func setUp() {
        super.setUp()
        app.launch()
    }

    override func tearDown() {
        setItems(to: [])
        super.tearDown()
    }

    func test_AddItemBarButton_Canceled() {
        let navigationBars = app.navigationBars
        navigationBars["All Items"].buttons["Add Item"].tap()
        navigationBars["Add Item"].buttons["Cancel"].tap()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_AddItemBarButton_Canceled_Item() {
        let navigationBars = app.navigationBars
        navigationBars["All Items"].buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        navigationBars["Add Item"].buttons["Cancel"].tap()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_AddItemBarButton_Saved_Item() {
        let navigationBars = app.navigationBars
        navigationBars["All Items"].buttons["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars.buttons["Save"].tap()
        assertAppIsDisplayingAllItems()
        assertApp(isDisplaying: item0)
        app.terminate()
        app.launch()
        assertApp(isDisplaying: item0)
    }

    func test_AddItemCell_Canceled() {
        
        app.cells.staticTexts["Add Item"].tap()
        app.navigationBars["Add Item"].buttons["Cancel"].tap()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_AddItemCell_Canceled_Item() {
        
        app.cells.staticTexts["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars["Add Item"].buttons["Cancel"].tap()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_AddItemCell_Saved_Item() {
        app.cells.staticTexts["Add Item"].tap()
        app.textViews["Body"].typeText("This is just a test.")
        app.navigationBars.buttons["Save"].tap()
        assertAppIsDisplayingAllItems()
        assertApp(isDisplaying: item0)
        app.terminate()
        app.launch()
        assertApp(isDisplaying: item0)
    }

    // MARK: - Helper Functions

    private func assertAppIsDisplayingAddItemScreen() {
        let element = XCUIApplication().navigationBars["Add Item"]
        assertApp(isDisplaying: element)
    }
}
