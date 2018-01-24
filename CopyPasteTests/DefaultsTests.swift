//
//  DefaultsTests.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 1/26/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class DefaultsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        DefaultsContext().reset()
    }

    func test_Defaults_Init() {
        let defaults = Defaults()
        XCTAssertTrue(defaults.showWelcome)
    }

    func test_Defaults_Init_With_Value() {
        let defaults = Defaults(showWelcome: false)
        XCTAssertFalse(defaults.showWelcome)
    }

    func test_DefaultsContext_Init() {
        let context = DefaultsContext()
        XCTAssertTrue(context.defaults.showWelcome)
    }

    func test_Save() {
        let context = DefaultsContext()
        XCTAssertTrue(context.defaults.showWelcome)
        let defaults = Defaults(showWelcome: false)
        context.save(defaults)
        XCTAssertFalse(context.defaults.showWelcome)
    }

    func test_Reset() {
        let context = DefaultsContext()
        XCTAssertTrue(context.defaults.showWelcome)
        let defaults = Defaults(showWelcome: false)
        context.save(defaults)
        XCTAssertFalse(context.defaults.showWelcome)
        context.reset()
        XCTAssertTrue(context.defaults.showWelcome)
    }
}
