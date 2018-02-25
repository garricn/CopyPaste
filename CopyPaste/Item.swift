//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

public struct Item: Codable {
    public let body: String
    public let copyCount: Int
    public let title: String?

    public init(body: String = "", copyCount: Int = 0, title: String? = nil) {
        self.body = body
        self.copyCount = copyCount
        self.title = title
    }
}

internal func copyCountDescending(a: Item, b: Item) -> Bool {
    return a.copyCount > b.copyCount
}
