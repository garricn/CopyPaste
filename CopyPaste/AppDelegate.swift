//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appFlow: AppFlow = AppFlow(window: self.window)

    func application(_ application: App, willFinishLaunchingWithOptions launchOptions: LaunchOptions? = nil) -> Bool {
        let launch = Launch(options: launchOptions)
        return appFlow.willFinish(launch)
    }

    func application(_ application: App, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        let launch = Launch(options: launchOptions)
        return appFlow.didFinish(launch)
    }


    func application(_ application: App, performActionFor shortcutItem: Shortcut, completionHandler: @escaping (Bool) -> Void) {
        appFlow.performAction(for: shortcutItem, completion: completionHandler)
    }
}

typealias LaunchOptions = [UIApplicationLaunchOptionsKey: Any]
typealias Shortcut = UIApplicationShortcutItem
typealias App = UIApplication
