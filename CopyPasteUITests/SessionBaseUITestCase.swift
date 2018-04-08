//
//  SessionBaseUITestCase.swift
//  CopyPasteUITests
//
//  Created by Garric Nahapetian on 3/31/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import XCTest

class SessionBaseUITestCase: UITestCase {
    
    override func setUp() {
        super.setUp()
        addCodableEnvironmentVariable(Defaults(showWelcome: false), forName: Globals.EnvironmentVariables.defaults)
    }
}
