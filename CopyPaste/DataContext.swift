//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

public final class DataContext<D: Codable> {
    
    private(set) var data: D
    
    private let initialValue: D
    private let store: DataStore
    
    public init(initialValue: D, store: DataStore) {
        self.initialValue = initialValue
        self.store = store
        
        if let decoded = store.decode(D.self) {
            data = decoded
        } else {
            data = initialValue
        }
        
        defer {
            store.encode(data)
        }
        
        #if DEBUG
        let key = Globals.EnvironmentVariables.codables.appending(store.name)
        let string = ProcessInfo.processInfo.environment[key]
        
        guard let data = string?.data(using: .utf8), let decoded = store.decode(type: D.self, from: data) else {
            return
        }
        
        self.data = decoded
        #endif
    }

    public func save(_ data: D) {
        self.data = data
        store.encode(data)
    }
    
    public func reset() {
        data = initialValue
        store.encode(data)
    }
}
