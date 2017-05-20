//
//  AppLaunchUITestCase.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/13/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class AppLaunchUITestCase: UITestCase {

    func test_Normal_App_Launch() {
        assertAppIsDisplayingAllItems()
        let element = XCUIApplication().tables.cells["Add Item"]
        assertApp(isDisplaying: element)
    }
}
