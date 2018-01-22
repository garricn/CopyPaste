//
//  LaunchTestCase.swift
//  CopyPasteTests
//
//  Created by Garric G. Nahapetian on 12/17/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

final class LaunchTestCase: XCTestCase {
    
    func test_LaunchReason_isNormal_Given_Nil() {
        let reason = Launch.Reason(launchOptions: nil)
        guard case .normal = reason else {
            XCTFail()
            return
        }
    }

    func test_LaunchReason_isShortcutItem_Given_ShortcutItem() {
        let type = "com.swiftcoders.copypaste.newitem"
        let shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: "")
        let options: Options = [.shortcutItem: shortcutItem]
        let reason = Launch.Reason(launchOptions: options)
        guard case .shortcut = reason else {
            XCTFail()
            return
        }
    }

    func test_First_App_Launch() {
        let defaults = Defaults(shouldResetUserDefaults: true)
        let launch = Launch(options: nil, defaults: defaults)
        XCTAssertTrue(launch.reason.isNormal)
        XCTAssertEqual(launch.kind, .foreground)
        XCTAssertEqual(launch.state, .welcome)
    }
}
