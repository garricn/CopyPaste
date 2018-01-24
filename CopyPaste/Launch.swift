//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public struct Launch {
    let reason: Reason
    let state: State

    var kind: Kind {
        return reason.kind
    }
}

// MARK: - Custom Initializers

public extension Launch {

    public init(options: Options?, defaults: Defaults = Defaults()) {
        self.init(reason: Reason(launchOptions: options), defaults: defaults)
    }

    public init(arguments: [Launch.Argument], defaults: Defaults = Defaults()) {
        let statement = "Unexpected number of LaunchArguments."
        let question = "Did you forget to add a new case to the static var `all`?"
        let message = "\(statement) \(question)"

        guard arguments.count <= Launch.Argument.all.count else {
            fatalError(message)
        }

        self.init(reason: Reason(arguments: arguments), defaults: defaults)
    }

    private init(reason: Reason, defaults: Defaults) {
        self.reason = reason
        self.state = defaults.shouldShowWelcomeScreen ? .welcome : .session
    }
}


// MARK: - Nested Types

public extension Launch {

    public enum Argument: String {
        case isUITesting = "isUITesting"
        case resetUserDefaults = "resetUserDefaults"
        case resetData = "resetData"
        case newItemShortcutItem = "newItemShortcutItem"

        static var all: [Argument] {
            return [
                .isUITesting,
                .resetUserDefaults,
                .resetData,
                .newItemShortcutItem
            ]
        }
    }
}
public extension Launch {
    public enum Kind {
        case foreground
        case background
    }
}

public extension Launch {
    public enum Reason {
        case normal
        case shortcut(ShortcutItem)
    }
}

public extension Launch.Reason {
    public init(launchOptions: Options?) {
        guard let options = launchOptions else {
            self = .normal
            return
        }

        self = .shortcut(ShortcutItem(options: options)!)
    }

    public init(arguments: [Launch.Argument]) {
        guard !arguments.isEmpty,
            let index = arguments.index(of: .newItemShortcutItem),
            let item = ShortcutItem(argument: arguments[index]) else {
                self = .normal
                return
        }

        self = .shortcut(item)
    }
}

public extension Launch.Reason {

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

    public var isNormal: Bool {
        if case .normal = self {
            return true
        } else {
            return false
        }
    }

    public var isShortcut: Bool {
        if case .shortcut = self {
            return true
        } else {
            return false
        }
    }
}

public extension Launch {
    public enum State {
        case welcome
        case session
    }
}
