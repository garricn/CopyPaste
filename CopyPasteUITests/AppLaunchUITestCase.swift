//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

final class AppLaunchUITestCase: UITestCase {

    func test_Fresh_Install_Launch() {
        setDefaults(to: Defaults())
        setItems(to: [])
        
        app.launch()
        app.buttons["Get Started"].tap()

        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        app.terminate()
        app.launchEnvironment.removeValue(forKey: Globals.EnvironmentVariables.resetDefaults)
        app.launch()
        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()

    }

    func test_NewItem_ShortcutItem_Launch() {
        
        app.launchEnvironment = [UIApplicationLaunchOptionsKey.shortcutItem.rawValue: Globals.ShortcutItemTypes.newItem,
                                 Globals.EnvironmentVariables.showWelcome: "false"]
        app.launch()
        let element = app.navigationBars["Add Item"]
        assertApp(isDisplaying: element)

        app.launchEnvironment.removeValue(forKey: UIApplicationLaunchOptionsKey.shortcutItem.rawValue)
    }
}

final class HappyPathUITestCase: UITestCase {

    func test_HappyPath() {
        app.launchEnvironment[Globals.EnvironmentVariables.resetDefaults] = "true"
        app.launchEnvironment[Globals.EnvironmentVariables.resetData] = "true"
    }
}
