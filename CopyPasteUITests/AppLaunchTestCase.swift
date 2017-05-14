//
//  AppLaunchTestCase.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/13/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class AppLaunchTestCase: TestCase {

    func testNormalAppLaunch() {
        assertAppIsDisplayingAllItems()
        let element = XCUIApplication().tables.cells["Add Item"]
        assertApp(isDisplaying: element)
    }
}
