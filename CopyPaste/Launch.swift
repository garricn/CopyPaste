//
//  Launch.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 12/2/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

struct Launch {

    enum Kind {
        case foreground
        case background
    }

    enum Reason {
        case normal
        case shortcut(ShortcutItem)

        var kind: Kind {
            return .foreground
        }

        var isNormal: Bool {
            if case .normal = self {
                return true
            } else {
                return false
            }
        }

        var isShortcut: Bool {
            if case .shortcut = self {
                return true
            } else {
                return false
            }
        }

        init(launchOptions: Options?) {
            guard let options = launchOptions else {
                self = .normal
                return
            }

            guard let shortcut = options[.shortcutItem] as? UIApplicationShortcutItem,
                let item = ShortcutItem(item: shortcut) else {
                    fatalError()
            }

            self = .shortcut(item)
        }

        init(arguments: [String]) {
            guard !arguments.isEmpty else {
                self = .normal
                return
            }

            let itemType = "com.swiftcoders.copypaste.newitem"
            let shortcutItem = UIApplicationShortcutItem(type: itemType, localizedTitle: "")

            guard arguments.contains(itemType), let item = ShortcutItem(item: shortcutItem) else {
                fatalError()
            }

            self = .shortcut(item)
        }
    }

    enum State {
        case welcome
        case session
    }

    let reason: Reason
    let state: State

    var kind: Kind { return reason.kind }

    init(options: Options?, defaults: Defaults = Defaults()) {
        self.init(reason: Reason(launchOptions: options), defaults: defaults)
    }

    init(arguments: [String], defaults: Defaults = Defaults()) {
        self.init(reason: Reason(arguments: arguments), defaults: defaults)
    }

    private init(reason: Reason, defaults: Defaults) {
        self.reason = reason
        self.state = defaults.shouldShowWelcomeScreen ? .welcome : .session
    }
}
