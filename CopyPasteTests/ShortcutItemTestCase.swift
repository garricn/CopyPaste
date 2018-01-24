//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class ShortcutItemTestCase: XCTestCase {

    func test_AllCases() {
        for item in ShortcutItem.all {
            switch item {
            case .newItem:
                break
            }
        }
    }

    func test_Unsupported_ShortcutItem() {
        XCTAssertNil(ShortcutItem(item: UIApplicationShortcutItem(type: "unsupported", localizedTitle: "")))
    }

    func test_ShortcutItem_Is_NewItem_Given_NewItem() {
        let type = Globals.ShortcutItemTypes.newItem
        let item = UIApplicationShortcutItem(type: type, localizedTitle: "")
        let shorcut = ShortcutItem(item: item)!
        XCTAssertTrue(shorcut.isNewItem)
    }
}

extension ShortcutItem {
    var isNewItem: Bool {
        if case .newItem = self {
            return true
        } else {
            return false
        }
    }
}
