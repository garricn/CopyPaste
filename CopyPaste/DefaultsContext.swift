//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

public final class DefaultsContext {

    private(set) var defaults: Defaults

    private let dataStore: DataStore

    public init(dataStore: DataStore = DataStore()) {
        self.dataStore = dataStore

        defaults = dataStore.decode(Defaults.self) ?? Defaults()
        
        defer {
            save(defaults)
        }

        #if DEBUG // Start: Get Decoded Data from .utf8 encoding String
        
        // get string for key
        guard let encodedString = ProcessInfo.processInfo.environment[Globals.EnvironmentVariables.defaults] else {
            return
        }
        
        // convert string to data
        guard let data = encodedString.data(using: .utf8) else {
            return
        }
        
        // convert to data to items
        guard let decodedDefaults = dataStore.decode(type: Defaults.self, from: data) else {
            return
        }
        
        self.defaults = decodedDefaults
        #endif // End
    }

    public func save( _ defaults: Defaults) {
        self.defaults = defaults
        dataStore.encode(defaults)
    }

    public func reset() {
        save(Defaults())
    }
}
