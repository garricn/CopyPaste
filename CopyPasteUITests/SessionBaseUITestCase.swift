//
//  SessionBaseUITestCase.swift
//  CopyPasteUITests
//
//  Created by Garric Nahapetian on 3/31/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste
import XCTest

class SessionBaseUITestCase: UITestCase {
    
    override func setUp() {
        super.setUp()
        let name = Globals.EnvironmentVariables.defaults
        addCodableEnvironmentVariable(Defaults(showWelcome: false), forName: name)
    }
    
    public func addItem(_ item: Item) {
        let navigationBars = app.navigationBars
        navigationBars["All Items"].buttons["Add Item"].tap()
        app.textViews["Body"].typeText(item.body)
        app.navigationBars.buttons["Save"].tap()
    }
}
