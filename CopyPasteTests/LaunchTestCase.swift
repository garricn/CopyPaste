//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

final class LaunchTestCase: XCTestCase {

    func test_Reason_Is_Normal_Given_Nil_Options() {
        let launch = Launch(options: nil)
        XCTAssertTrue(launch.reason.isNormal)
        XCTAssertTrue(launch.kind.isForeground)
    }

    func test_Reason_Is_Normal_Given_Empty_Options() {
        let launch = Launch(options: [:])
        XCTAssertTrue(launch.reason.isNormal)
        XCTAssertTrue(launch.kind.isForeground)
    }

    func test_Reason_Is_Shortcut_Given_UIApplicationShortcutItem() {
        let type = Globals.ShortcutItemTypes.newItem
        let item = UIApplicationShortcutItem(type: type, localizedTitle: "")
        let options = [UIApplicationLaunchOptionsKey.shortcutItem: item]
        let launch = Launch(options: options)
        XCTAssertTrue(launch.reason.isShortcut)
        XCTAssertTrue(launch.kind.isForeground)
    }
}

public extension Launch.Reason {
    var isShortcut: Bool {
        if case .shortcut = self {
            return true
        } else {
            return false
        }
    }
    var isNormal: Bool {
        if case .normal = self {
            return true
        } else {
            return false
        }
    }
}

public extension Launch.Kind {
    var isForeground: Bool {
        if case .foreground = self {
            return true
        } else {
            return false
        }
    }

    var isBackground: Bool {
        if case .background = self {
            return true
        } else {
            return false
        }
    }
}
