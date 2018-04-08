//
//  DefaultsTests.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 1/26/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class DefaultsTests: BaseTestCase {

    private var subject: DataContext<Defaults>!

    override func setUp() {
        super.setUp()
        let name = Globals.EnvironmentVariables.defaults
        subject = DataContext<Defaults>.init(initialValue: .init(), store: DataStore.init(name: name))
        subject.reset()
    }

    func testFoo() {
        XCTAssertEqual(subject.data.showWelcome, true)
        subject.save(Defaults(showWelcome: false))
        XCTAssertEqual(subject.data.showWelcome, false)
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
        XCTAssertTrue(subject.data.showWelcome)
    }

    func test_Save() {
        XCTAssertTrue(subject.data.showWelcome)
        subject.save(Defaults(showWelcome: false))
        XCTAssertFalse(subject.data.showWelcome)
    }

    func test_Reset() {
        XCTAssertTrue(subject.data.showWelcome)
        
        subject.save(Defaults(showWelcome: false))
        XCTAssertFalse(subject.data.showWelcome)
        
        subject.reset()
        XCTAssertTrue(subject.data.showWelcome)
    }
}
