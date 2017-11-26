//
//  CopyContext.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

final class CopyContext {

    private(set) var items: [Item]

    private let dataStore: DataStore

    init(dataStore: DataStore, shouldResetItems: Bool = false) {
        self.dataStore = dataStore

        if shouldResetItems {
            self.items = []
        } else {
            self.items = dataStore.decode([Item].self) ?? []
        }
    }

    func save(_ items: [Item]) {
        self.items = items
        dataStore.encode(items)
    }
}
