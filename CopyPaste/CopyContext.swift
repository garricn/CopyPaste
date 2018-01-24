//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

final class CopyContext {

    private(set) var items: [Item]

    private let dataStore: DataStore

    init(dataStore: DataStore = DataStore(),
         shouldResetItems: Bool = CommandLine.arguments.contains(Globals.LaunchArguments.resetData)) {
        self.dataStore = dataStore

        if shouldResetItems {
            self.items = []
            save(items)
        } else {
            self.items = dataStore.decode([Item].self) ?? []
        }
    }

    func save(_ items: [Item]) {
        self.items = items
        dataStore.encode(items)
    }
}
