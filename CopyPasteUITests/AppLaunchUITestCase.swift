//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

final class AppLaunchUITestCase: UITestCase {
    
    override func tearDown() {
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.defaults)
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.items)
        app.launchEnvironment.removeValue(forKey: UIApplicationLaunchOptionsKey.shortcutItem.rawValue)
        super.tearDown()
    }
    
    func test_Fresh_Install_Launch() {
        setDefaults(to: Defaults())
        setItems(to: [])
        
        app.launch()
        app.buttons["Get Started"].tap()

        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        
        app.terminate()
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.defaults)
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.items)
        app.launch()
        
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }
    
    func testSecondAppLaunch() {
        setDefaults(to: Defaults(showWelcome: false))
        setItems(to: [])
        app.launch()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
    }
    
    func testLaunchWithData() {
        setDefaults(to: Defaults(showWelcome: false))
        setItems(to: [Item.init(body: "Body", copyCount: 0, title: "Title")])
        app.launch()
        assertAppIsDisplayingAllItems()
        let element = app.cells.staticTexts["Body"]
        assertApp(isDisplaying: element)
    }
    
    func test_NewItem_ShortcutItem_Launch() {
        setDefaults(to: Defaults(showWelcome: false))
        setItems(to: [])

        app.launchEnvironment[UIApplicationLaunchOptionsKey.shortcutItem.rawValue] = Globals.ShortcutItemTypes.newItem
        app.launch()

        let element = app.navigationBars["Add Item"]
        assertApp(isDisplaying: element)
        app.launchEnvironment.removeValue(forKey: UIApplicationLaunchOptionsKey.shortcutItem.rawValue)
    }
}
