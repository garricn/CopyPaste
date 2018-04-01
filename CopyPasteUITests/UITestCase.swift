//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {

    private static let sharedApp: XCUIApplication = .init()

    var app: XCUIApplication { return UITestCase.sharedApp }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func assertAppIsDisplayingAllItems() {
        
        let element = app.navigationBars["All Items"]
        assertApp(isDisplaying: element)
    }

    func assertAppIsDisplayingAddItemCell() {
        let element = XCUIApplication().cells.staticTexts["Add Item"]
        assertApp(isDisplaying: element)
    }
    
    func setItems(to items: [Item]) {
        let data = try! JSONEncoder().encode(items)
        let string = String(data: data, encoding: .utf8)
        app.launchEnvironment[Globals.EnvironmentVariables.items] = string
    }
    
    func setDefaults(to defaults: Defaults) {
        let data = try! JSONEncoder().encode(defaults)
        let string = String(data: data, encoding: .utf8)
        app.launchEnvironment[Globals.EnvironmentVariables.defaults] = string
    }
}
