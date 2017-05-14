//
//  TestCase.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/13/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

class TestCase: XCTestCase {

    var app: XCUIApplication { return XCUIApplication() }

    var navigationBars: XCUIElementQuery { return app.navigationBars }

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
