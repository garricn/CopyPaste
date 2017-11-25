//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appFlow: AppFlow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        let context = AppContext(application: application, launchOptions: launchOptions)
        appFlow = AppFlow(context: context, window: window)
        return appFlow.didFinishLaunching()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        appFlow.applicationWillTerminate()
    }
}

typealias LaunchOptions = [UIApplicationLaunchOptionsKey: Any]
