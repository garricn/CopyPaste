//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class AppLaunchUITestCase: UITestCase {

    func test_First_App_Launch() {
        let app = XCUIApplication()
        app.launchArguments.append("resetData")
        app.launchArguments.append("resetDefaults")
        app.launch()
        app.buttons["Get Started"].tap()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_Normal_App_Launch() {
        XCUIApplication().launch()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }

    func test_NewItem_ShortcutItem_Launch() {
        let app = XCUIApplication()
        app.launchArguments.append("isUITesting")
        app.launchArguments.append("newItemShortcutItem")
        app.launch()

        let element = app.navigationBars["Add Item"]
        assertApp(isDisplaying: element)
    }
}
