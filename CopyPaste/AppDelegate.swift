//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var appFlow: AppFlow = .init()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return appFlow.didFinishLaunching(withOptions: launchOptions)
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        appFlow.performAction(for: shortcutItem, completion: completionHandler)
    }
}

private class AppFlow {

    private var context: DefaultsContext = .init()
    private var windowFlow: WindowFlow = .init()

    func didFinishLaunching(withOptions options: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let startReason: CopyFlow.StartReason

        defer {
            windowFlow.start(mode: .session(startReason))
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
        case session(CopyFlow.StartReason)
    }

    private let window = UIWindow()
    private let rootViewController: RootViewController = .init()

    lazy var sessionFlow: CopyFlow = .init()

    func start(mode: Mode) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        switch mode {
        case let .session(reason):
            sessionFlow.start(withParent: rootViewController, reason: reason)
        }
    }

    func performAction(for shortcutItem: UIApplicationShortcutItem, completion: @escaping (Bool) -> Void) {
        let item = ShortcutItem(item: shortcutItem, completion: completion)
        sessionFlow.performAction(for: item!)
    }
}

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
