//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class DeleteUITestCase: SessionBaseUITestCase {

    override func setUp() {
        super.setUp()
        setItems(to: [])
        app.launch()
    }

    override func tearDown() {
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.items)
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
}
