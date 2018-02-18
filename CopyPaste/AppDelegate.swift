//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var flow: Flow = .init()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return flow.didFinishLaunching(withOptions: launchOptions)
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        flow.performAction(for: shortcutItem, completion: completionHandler)
    }
}

private class Flow {

    private var context: DefaultsContext = .init()
    private var windowFlow: WindowFlow = .init()

    func didFinishLaunching(withOptions options: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let startReason: CopyFlow.StartReason

        defer {
            let mode: WindowFlow.Mode
            switch context.defaults.showWelcome {
            case true:
                mode = .unathenticated
            case false:
                mode = .authenticated(startReason)
            }

            windowFlow.start(mode: mode)
        }

        guard let options = options, !options.isEmpty else {
            startReason = .normal
            return true
        }

        guard options.count == 1, let shortcutItem = options[.shortcutItem] as? UIApplicationShortcutItem  else {
            assertionFailure("undefined")
            startReason = .normal
            return true
        }

        guard shortcutItem.type == Globals.ShortcutItemTypes.newItem else {
            assertionFailure("undefined")
            startReason = .normal
            return true
        }

        startReason = .shortcut(ShortcutItem.init(item: shortcutItem)!)
        return false
    }

    func performAction(for shortcutItem: UIApplicationShortcutItem, completion: @escaping (Bool) -> Void) {
        windowFlow.performAction(for: shortcutItem, completion: completion)
    }
}

class WindowFlow {

    enum Mode {
        case authenticated(CopyFlow.StartReason)
        case unathenticated
    }

    private let window = UIWindow()
    private let rootViewController: RootViewController = .init()

    lazy var authenticatedFlow: CopyFlow = .init()
    lazy var unauthenticatedFlow: WelcomeViewController = .init()

    func start(mode: Mode) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        switch mode {
        case let .authenticated(reason):
            authenticatedFlow.start(withParent: rootViewController, reason: reason)
        case .unathenticated:
            unauthenticatedFlow.onDidTapGetStarted { [weak self] in
                self?.rootViewController.dismiss(animated: true) { [weak self] in
                    self?.authenticatedFlow.start(withParent: self!.rootViewController, reason: .normal)
                }
            }
        }
    }

    func performAction(for shortcutItem: UIApplicationShortcutItem, completion: @escaping (Bool) -> Void) {
        let item = ShortcutItem.init(item: shortcutItem, completion: completion)
        authenticatedFlow.performAction(for: item!)
    }
}

class AuthenticatedFlow {}
class UnauthenticatedFlow {}

class RootViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
