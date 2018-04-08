//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public extension AppFlow {
    public struct Launch {
        let reason: Reason
    }
}

public extension AppFlow.Launch {

    public enum Reason {
        case normal
        case shortcut(ShortcutItem)

        public var kind: Kind {
            switch self {
            case .normal:
                return .foreground
            case let .shortcut(item):
                switch item {
                case .newItem:
                    return .foreground
                }
            }
        }
    }

    public enum Kind {
        case foreground
    }
}

public extension AppFlow.Launch {

    var kind: Kind {
        return reason.kind
    }

    public init(options: [UIApplicationLaunchOptionsKey: Any]?) {
        var launchOptions: [UIApplicationLaunchOptionsKey: Any] = options ?? [:]

        #if DEBUG
        let key = Globals.EnvironmentVariables.shortcutItemKey
        if let type = ProcessInfo.processInfo.environment[key] {
            let item = UIApplicationShortcutItem(type: type, localizedTitle: "")
            let key = UIApplicationLaunchOptionsKey(key)
            launchOptions[key] = item
        }
        #endif

        guard !launchOptions.isEmpty else {
            reason = .normal
            return
        }

        guard launchOptions.count == 1
            , let appItem = launchOptions[.shortcutItem] as? UIApplicationShortcutItem
            , let item = ShortcutItem(item: appItem) else {
                fatalError()
        }

        reason = .shortcut(item)
    }
}
