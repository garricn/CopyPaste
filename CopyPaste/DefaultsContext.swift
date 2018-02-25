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
        dataStore.encode(defaults)

        // NOTE: - Too many decisions happing down there
        // one debug in/output: [DefaultKey: DefaultValue] // to be determined
        // not two: showWelcome and resetDefault
        #if DEBUG
            let environment = ProcessInfo.processInfo.environment
            let key = Globals.EnvironmentVariables.showWelcome
            if let value = environment[key], let bool = Bool(string: value) {
                let defaults = Defaults(showWelcome: bool)
                save(defaults)
            } else if ProcessInfo.processInfo.environment[Globals.EnvironmentVariables.resetDefaults] != nil {
                reset()
            }
        #endif
    }

    public func save( _ defaults: Defaults) {
        self.defaults = defaults
        dataStore.encode(defaults)
    }

    public func reset() {
        save(Defaults())
    }
}

public struct Defaults: Codable {
    public var showWelcome = true
}
