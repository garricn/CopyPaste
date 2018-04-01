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
        application.sheets["RESET"].buttons[resetAction.rawValue].tap()
    func setItems(to items: [Item]) {
        let data = try! JSONEncoder().encode(items)
        let string = String(data: data, encoding: .utf8)
        app.launchEnvironment[Globals.EnvironmentVariables.items] = string
    }
    public enum ResetAction {
        case data
        case userDefaults
        case dataAndUserDefaults
        case cancel
        
        var rawValue: String {
            switch self {
            case .data:
                return Globals.UITestingResetAction.data
            case .userDefaults:
                return Globals.UITestingResetAction.defaults
            case .dataAndUserDefaults:
                return Globals.UITestingResetAction.dataAndDefaults
            case .cancel:
                return Globals.UITestingResetAction.cancel
            }
        }
    func setDefaults(to defaults: Defaults) {
        let data = try! JSONEncoder().encode(defaults)
        let string = String(data: data, encoding: .utf8)
        app.launchEnvironment[Globals.EnvironmentVariables.defaults] = string
    }
}
