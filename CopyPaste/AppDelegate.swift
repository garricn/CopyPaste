//
//  AppDelegate.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 4/5/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let items = ItemObject.unarchived().map(toItem).sorted(by: copyCountDescending)
        let rootViewController = TableViewController(items: items)

        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

func copyCountDescending(a: Item, b: Item) -> Bool {
    return a.copyCount > b.copyCount
}
