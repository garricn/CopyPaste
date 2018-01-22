//
//  ShortcutItemTestCase.swift
//  CopyPasteTests
//
//  Created by Garric G. Nahapetian on 12/17/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class ShortcutItemTestCase: XCTestCase {

    func test_Unsupported_ShortcutItem() {
        let item = UIApplicationShortcutItem(type: "unsupported", localizedTitle: "")
        let subject = ShortcutItem(item: item)
        XCTAssertNil(subject)
    }

    func test_NewItem_ShortcutItem() {
        let item = UIApplicationShortcutItem(type: "com.swiftcoders.copypaste.newitem", localizedTitle: "")
        let subject = ShortcutItem(item: item)!
        guard case .newItem = subject else {
            XCTFail()
            return
        }
    }
}
