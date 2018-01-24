//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appFlow: AppFlow = AppFlow(window: self.window)

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let launch = Launch(options: launchOptions)
        return appFlow.willFinish(launch)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launch = Launch(options: launchOptions)
        return appFlow.didFinish(launch)
    }


    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appFlow.performAction(for: shortcutItem, completion: completionHandler)
    }
}
