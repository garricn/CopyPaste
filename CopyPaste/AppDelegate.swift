//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var environmentFlow: EnvironmentFlow = .init()
    lazy var foregroundFlow: ForegroundFlow = .init()
    lazy var backgroundFlow: BackgroundFlow = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: Options?) -> Bool {

        let launch = environmentFlow.didFinishLaunch(CommandLine.self, launchOptions)

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
        let item = ShortcutItem(item: shortcutItem, completion: completionHandler)!
        foregroundFlow.performAction(for: item)
    }
}

public typealias Options = [UIApplicationLaunchOptionsKey: Any]
