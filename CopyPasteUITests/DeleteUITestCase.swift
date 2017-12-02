//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class DeleteUITestCase: UITestCase {

    var bodyText: String { return "This is just a test." }

    var bodyTextView: XCUIElement { return app.textViews["Body"] }

    var saveBarButton: XCUIElement { return navigationBars.buttons["Save"] }

    func test_Swipe_To_Delete() {
        addItemBarButton.tap()
        bodyTextView.typeText(bodyText)
        saveBarButton.tap()

        app.cells.staticTexts[bodyText].swipeLeft()
        app.tables.buttons["Delete"].tap()

        assertApp(isDisplaying: addItemCell)
    }

    func test_Edit_Button_Delete() {
        addItemBarButton.tap()
        bodyTextView.typeText(bodyText)
        saveBarButton.tap()

        editBarButton.tap()
        
        let tables = app.tables
        tables.cells.buttons["Delete \(bodyText), 0"].tap()
        tables.buttons["Delete"].tap()
        assertApp(isDisplaying: addItemCell)
    }

    func test_Delete_Multple_Items() {
        addItemBarButton.tap()
        bodyTextView.typeText("Item 0")
        saveBarButton.tap()

        addItemBarButton.tap()
        bodyTextView.typeText("Item 1")
        saveBarButton.tap()

        app.cells.staticTexts["Item 0"].swipeLeft()
        app.tables.buttons["Delete"].tap()

        app.cells.staticTexts["Item 1"].swipeLeft()
        app.tables.buttons["Delete"].tap()

        assertApp(isDisplaying: addItemCell)
    }
}
