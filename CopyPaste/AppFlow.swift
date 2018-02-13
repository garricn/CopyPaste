//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public final class AppFlow {

    internal lazy var foregroundFlow: ForegroundFlow = .init()

    internal var window: UIWindow?

    public init(window: UIWindow? = nil) {
        self.window = window
    }
}

// MARK: - Launch

public extension AppFlow {

    public func didFinish(_ launch: Launch) -> Bool {
        switch launch.kind {
        case .window:
            let window = UIWindow()
            window.rootViewController = foregroundFlow.rootView
            window.makeKeyAndVisible()
            self.window = window

            foregroundFlow.start(for: launch.reason)
        }

        switch launch.reason {
        case .normal:
            return true
        case .shortcut:
            return false
        }
    }
}

// MARK: - ShortcutItem

public extension AppFlow {

    @discardableResult
    public func performAction(for shortcutItem: UIApplicationShortcutItem, completion: @escaping (Bool) -> Void) -> Bool {
        assert(window?.rootViewController != nil)

        if let item = ShortcutItem(item: shortcutItem, completion: completion) {
            foregroundFlow.performAction(for: item)
            return true
        } else {
            return false
        }
    }
}
