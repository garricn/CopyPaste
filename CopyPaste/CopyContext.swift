//
//  CopyContext.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

final class CopyContext {
    private let dataStore: DataStore
    private(set) var items: [Item]
    init(dataStore: DataStore, shouldResetItems: Bool) {
        self.dataStore = dataStore
        if shouldResetItems {
            self.items = []
        } else {
            self.items = dataStore.decode([Item].self) ?? []
        }
    }
    func set(items: [Item]) {
        self.items = items
    }
    func saveItems() {
        dataStore.encode(items)
    }
}
