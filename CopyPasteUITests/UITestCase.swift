//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {

    var app: XCUIApplication { return XCUIApplication() }

    var navigationBars: XCUIElementQuery { return app.navigationBars }

    var allItemsNavigationBar: XCUIElement { return app.navigationBars["All Items"] }

    var addItemBarButton: XCUIElement { return allItemsNavigationBar.buttons["Add Item"] }

    var editBarButton: XCUIElement { return allItemsNavigationBar.buttons["Edit"] }

    var addItemCell: XCUIElement { return app.tables.cells["Add Item"] }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("reset")
        app.launch()
    }

    func assertAppIsDisplayingAllItems() {
        let app = XCUIApplication()
        let element = app.navigationBars["All Items"]
        assertApp(isDisplaying: element)
    }
}
