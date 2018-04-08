//
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public final class AppContext {
    
    static let shared: AppContext = .init()
    
    lazy var itemsContext: DataContext<[Item]> = {
        let name = Globals.EnvironmentVariables.items
        let context = DataContext<[Item]>(initialValue: [], store: DataStore(name: name))
        return context
    }()
    
    lazy var defaultsContext: DataContext<Defaults> = {
        let name = Globals.EnvironmentVariables.defaults
        let context = DataContext<Defaults>(initialValue: .init(), store: DataStore(name: name))
        return context
    }()
}

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
        case .foreground:
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
            fatalError("Unsupported!")
        }
    }
}
