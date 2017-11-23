//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

struct Item: Codable {
    let body: String
    let copyCount: Int

    init(body: String = "", copyCount: Int = 0) {
        self.body = body
        self.copyCount = copyCount
    }
}

func copyCountDescending(a: Item, b: Item) -> Bool {
    return a.copyCount > b.copyCount
}
