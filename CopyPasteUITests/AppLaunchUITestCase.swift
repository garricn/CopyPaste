//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

final class AppLaunchUITestCase: UITestCase {
    
    func test_Fresh_Install_Launch() {
        resetDefaultsContext()
        resetItemsContext()

        app.launch()
        app.buttons["Get Started"].tap()

        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        
        app.terminate()
        
        removeDefaultsEnvironmentVariable()
        removeItemsEnvironmentVariable()
        
        app.launch()
        
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }
    
    func testSecondAppLaunch() {
        addCodableEnvironmentVariable(Defaults(showWelcome: false), forName: Globals.EnvironmentVariables.defaults)
        resetItemsContext()
        
        app.launch()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        
        removeDefaultsEnvironmentVariable()
        removeItemsEnvironmentVariable()
    }
    
    func testLaunchWithData() {
        let defaults = Defaults(showWelcome: false)
        addCodableEnvironmentVariable(defaults, forName: Globals.EnvironmentVariables.defaults)
        let items = [Item(body: "Body", copyCount: 0, title: "Title")]
        addCodableEnvironmentVariable(items, forName: Globals.EnvironmentVariables.items)

        app.launch()
        assertAppIsDisplayingAllItems()
        assertApp(isDisplaying: app.cells.staticTexts["Body"])
        
        removeDefaultsEnvironmentVariable()
        removeItemsEnvironmentVariable()
    }
    
    func test_NewItem_ShortcutItem_Launch() {
        let defaults = Defaults(showWelcome: false)
        addCodableEnvironmentVariable(defaults, forName: Globals.EnvironmentVariables.defaults)
        
        let key = Globals.EnvironmentVariables.shortcutItemKey
        app.launchEnvironment[key] = Globals.ShortcutItemTypes.newItem
        app.launch()

        let element = app.navigationBars["Add Item"]
        assertApp(isDisplaying: element)
        
        app.launchEnvironment.removeValue(forKey: key)
        removeDefaultsEnvironmentVariable()
        removeItemsEnvironmentVariable()
    }
}
