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
}

public final class UITestHelper {
    public static func debugPerform(resetAction: ResetAction, application: XCUIApplication) {
        application.navigationBars["All Items"].buttons["debug"].tap()
        application.sheets["DEBUG"].buttons[resetAction.rawValue].tap()
    }

    public enum ResetAction: String {
        case data = "debug.resetdata"
        case userDefaults = "debug.resetuserdefaults"
        case dataAndUserDefaults = "debug.resetboth"
        case cancel = "Cancel"
    }
}
