//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let items: [Item]
        if CommandLine.arguments.contains("reset") {
            items = []
            ItemObject.archive([])
        } else {
            items = ItemObject.unarchived().map(toItem).sorted(by: copyCountDescending)
        }

        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: TableViewController(items: items))
        window?.makeKeyAndVisible()
        return true
    }
}

func copyCountDescending(a: Item, b: Item) -> Bool {
    return a.copyCount > b.copyCount
}
