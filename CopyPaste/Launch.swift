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
        var launchOptions: [UIApplicationLaunchOptionsKey: Any]? = options

        #if DEBUG
            if let type = ProcessInfo.processInfo.environment[Globals.EnvironmentVariables.shortcutItemKey] {
                let item = UIApplicationShortcutItem.init(type: type, localizedTitle: "")
                let key = UIApplicationLaunchOptionsKey(Globals.EnvironmentVariables.shortcutItemKey)
                launchOptions = [key: item]
            }
        #endif

        guard let options = launchOptions, !options.isEmpty else {
            reason = .normal
            return
        }

        guard options.count == 1, let appItem = options[.shortcutItem] as? UIApplicationShortcutItem,
            let item = ShortcutItem(item: appItem) else {
                fatalError()
        }

        reason = .shortcut(item)
    }
}
