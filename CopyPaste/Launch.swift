//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public struct Launch {
    let options: [UIApplicationLaunchOptionsKey: Any]?
    let reason: Reason

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

        self.options = launchOptions
        self.reason = Reason(options: launchOptions)
    }

    public enum Reason {
        case normal
        case shortcut(ShortcutItem)

        public var kind: Launch.Kind {
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

        fileprivate init(options: [UIApplicationLaunchOptionsKey: Any]?) {
            guard let options = options else {
                self = .normal
                return
            }

            guard !options.isEmpty else {
                self = .normal
                return
            }

            guard options.count == 1 else {
                fatalError()
            }

            guard let applicationShortcutItem = options[.shortcutItem] as? UIApplicationShortcutItem else {
                fatalError()
            }

            guard let item = ShortcutItem(item: applicationShortcutItem) else {
                fatalError()
            }

            self = .shortcut(item)
        }
    }

    public enum Kind {
        case foreground
        case background
    }
}
