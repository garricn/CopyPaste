//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

// TODO: - Rename to Session context or DataContext<Item>

public final class CopyContext<D: Codable> {

    private(set) var items: [D]

    private let dataStore: DataStore

    public init(dataStore: DataStore = DataStore()) {
        self.dataStore = dataStore

        items = dataStore.decode([D].self) ?? []

        defer {
            save(items)
        }

        #if DEBUG // Start: Get Decoded Data from .utf8 encoding String

            // get string for key
            guard let encodedString = ProcessInfo.processInfo.environment[Globals.EnvironmentVariables.items] else {
                return
            }

            // convert string to data
            guard let data = encodedString.data(using: .utf8) else {
                return
            }

            // convert to data to items
            guard let decodedItems = dataStore.decode(type: [D].self, from: data) else {
                return
            }

            self.items = decodedItems
        #endif // End
    }

    public func save(_ items: [D]) {
        self.items = items
        dataStore.encode(items)
    }

    public func reset() {
        save([])
    }
}
