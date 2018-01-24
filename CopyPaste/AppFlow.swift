//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppFlow {

    enum Kind {
        case foreground
    }

    enum Reason {
        case normal
        case shortcutItem(ShortcutItem)
        var kind: Kind { return .foreground }
        var didFinishLaunching: Bool {
            switch self {
            case .shortcutItem:
                return false
            default:
                return true
            }
        }

        init(shortcutItem: ShortcutItem) {
            self = .shortcutItem(shortcutItem)
        }

        init(launchOptions: LaunchOptions?) {
            guard let options = launchOptions else {
                self = .normal
                return
            }
            self = .init(launchOptions: options)
        }

        private init(launchOptions: LaunchOptions) {
            guard let dict = launchOptions[.shortcutItem] as? UIApplicationShortcutItem else {
                fatalError("Application does not support other launch options")
            }
            let shortcutItem = ShortcutItem(item: dict)
            self = .shortcutItem(shortcutItem)
        }
    }

    enum State {
        case welcome
        case session
        init(reason: Reason, defaults: Defaults) {
            guard !defaults.shouldShowWelcomeScreen else {
                self = .welcome
                return
            }
            self = .session
        }
        init(reason: Reason) {
            self = .session
        }
    }

    struct Launch {
        let kind: Kind
        let reason: Reason
        let state: State
        let defaults: Defaults

        init(_ launchOptions: LaunchOptions?, _ defaults: Defaults = .init()) {
            self.reason = Reason(launchOptions: launchOptions)
            self.kind = reason.kind
            self.state = State(reason: reason, defaults: defaults)
            self.defaults = defaults
        }

        init(_ shortcutItem: ShortcutItem, _ defaults: Defaults = .init()) {
            self.reason = Reason(shortcutItem: shortcutItem)
            self.kind = reason.kind
            self.state = State(reason: reason)
            self.defaults = defaults
        }
    }

    private var window: UIWindow?

    private lazy var copyFlow: CopyFlow? = .init()

    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult
    func didFinish(launch: Launch) -> Bool {
        let presenter: UIViewController? = window?.rootViewController

        func startWelcomeFlow(completion: ((() -> Void))?) {
            let view = WelcomeViewController()
            presenter?.present(view, animated: true, completion: nil)
            view.onDidTapGetStarted {
                completion?()

                view.dismiss(animated: true) {
                    launch.defaults.shouldShowWelcomeScreen = false
                }
            }
        }


        if case .foreground = launch.kind, window?.rootViewController == nil {
            window = launch.kind == .foreground ? UIWindow() : nil
            window?.rootViewController = AppViewController()
            window?.makeKeyAndVisible()
        }

        if case .welcome = launch.state {
            startWelcomeFlow { [weak self] in
                self?.copyFlow?.start(with: presenter!, reason: launch.reason)
            }
        }

        guard case .session = launch.state else {
            fatalError("Application does not support launch state: \(launch.state)")
        }


        if copyFlow == nil {
            copyFlow?.start(with: presenter!, reason: launch.reason)
        }

        if case let .shortcutItem(item) = launch.reason {
            copyFlow?.performAction(for: item)
        }

        return launch.reason.didFinishLaunching
    }

    func performAction(for shortcutItem: ShortcutItem) {
        didFinish(launch: Launch(shortcutItem))
    }
}

