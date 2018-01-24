//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class ShortcutItemTestCase: XCTestCase {

    func test_Unsupported_ShortcutItem() {
        XCTAssertNil(ShortcutItem(item: UIApplicationShortcutItem(type: "unsupported", localizedTitle: "")))
    }

    func test_NewItem_ShortcutItem() {
        guard let subject = ShortcutItem(argument: .newItemShortcutItem) else {
            XCTFail()
            return
        }

        guard case .newItem = subject else {
            XCTFail()
            return
        }
    }
}
