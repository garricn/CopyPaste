//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var foregroundFlow: ForegroundFlow = .init()
    private lazy var backgroundFlow: BackgroundFlow = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: Options?) -> Bool {

        var arguments = CommandLine.arguments
        _ = arguments.removeFirst()
        let isUITesting = arguments.contains("isUITesting")
        let launch = isUITesting ? Launch(arguments: arguments) : Launch(options: launchOptions)

        switch launch.kind {
        case .foreground:
            window = UIWindow()
            window?.rootViewController = foregroundFlow.rootViewController
            window?.makeKeyAndVisible()
            return foregroundFlow.didFinish(launch)
        case .background:
            return backgroundFlow.didFinish(launch)
        }
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let item = ShortcutItem(item: shortcutItem, completion: completionHandler) else {
            return
        }

        foregroundFlow.performAction(for: item)
    }
}

typealias Options = [UIApplicationLaunchOptionsKey: Any]
