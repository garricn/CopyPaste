//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {

    private static let sharedApp: XCUIApplication = .init()

    var app: XCUIApplication { return UITestCase.sharedApp }
    
    public var allItemsElement: XCUIElement {
        return app.navigationBars["All Items"]
    }

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
    
    func addCodableEnvironmentVariable<E: Encodable>(_ encodable: E, forName name: String) {
        let data = try! JSONEncoder().encode(encodable)
        let string = String(data: data, encoding: .utf8)
        let key = Globals.EnvironmentVariables.codables.appending(name)
        app.launchEnvironment[key] = string
    }
    
    func resetItemsContext() {
        let empty: [Item] = []
        addCodableEnvironmentVariable(empty, forName: Globals.EnvironmentVariables.items)
    }
    
    func resetDefaultsContext() {
        addCodableEnvironmentVariable(Defaults(), forName: Globals.EnvironmentVariables.defaults)
    }
    
    func removeCodableEnvironmentVariable(name: String) {
        let key = Globals.EnvironmentVariables.codables.appending(name)
        app.launchEnvironment.removeValue(forKey: key)
    }
    
    func removeItemsEnvironmentVariable() {
        removeCodableEnvironmentVariable(name: Globals.EnvironmentVariables.items)
    }
    
    func removeDefaultsEnvironmentVariable() {
        removeCodableEnvironmentVariable(name: Globals.EnvironmentVariables.defaults)
    }
}
