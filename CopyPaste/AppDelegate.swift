//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appFlow: AppFlow = AppFlow(window: self.window)

    typealias App = UIApplication
    typealias Options = [UIApplicationLaunchOptionsKey: Any]
    func application(_ application: App, didFinishLaunchingWithOptions launchOptions: Options?) -> Bool {
        return appFlow.didFinish(.init(options: launchOptions))
    }

    typealias Item = UIApplicationShortcutItem
    typealias Handler = (Bool) -> Void
    func application(_ application: App, performActionFor shortcutItem: Item, completionHandler: @escaping Handler) {
        appFlow.performAction(for: shortcutItem, completion: completionHandler)
    }
}
