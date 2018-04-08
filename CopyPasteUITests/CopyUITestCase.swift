//
//  CopyUITestCase.swift
//  CopyPasteUITests
//
//  Created by Garric Nahapetian on 4/8/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste
import XCTest

final class CopyUITestCase: SessionBaseUITestCase {
    
    override func setUp() {
        super.setUp()
        resetItemsContext()
    }
    
    override func tearDown() {
        resetItemsContext()
        super.tearDown()
    }
    
    func testCopy() {
        let body = "This is some text."
        let item = Item.init(body: body)
        addCodableEnvironmentVariable([item], forName: Globals.EnvironmentVariables.items)
        
        app.launch()
        app.cells.staticTexts[body].tap()
        app.cells.staticTexts[body].swipeLeft()
        app.tables.buttons["Delete"].tap()
        app.navigationBars["All Items"].buttons["Add Item"].tap()
        app.textViews["Body"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app/*@START_MENU_TOKEN@*/.menuItems["Paste"]/*[[".menus.menuItems[\"Paste\"]",".menuItems[\"Paste\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Add Item"].buttons["Save"].tap()
        assertApp(isDisplaying: app.cells.staticTexts[body])
    }
}
