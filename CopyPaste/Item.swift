//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

public struct Item: Codable {
    public let body: String
    public let copyCount: Int

    public init(body: String = "", copyCount: Int = 0) {
        self.body = body
        self.copyCount = copyCount
    }
}

internal func copyCountDescending(a: Item, b: Item) -> Bool {
    return a.copyCount > b.copyCount
}
