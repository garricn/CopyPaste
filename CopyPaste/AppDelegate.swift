//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var appFlow: AppFlow = .init(window: self.window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        return appFlow.didFinishLaunching(application, launchOptions)
    }
}

typealias LaunchOptions = [UIApplicationLaunchOptionsKey: Any]
