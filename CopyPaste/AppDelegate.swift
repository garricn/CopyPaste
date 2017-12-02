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
        let launch = Launch(options: launchOptions)
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
        foregroundFlow.performAction(for: ShortcutItem(item: shortcutItem, completion: completionHandler))
    }
}

typealias Options = [UIApplicationLaunchOptionsKey: Any]
