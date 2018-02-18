////
////  AppFlowTestCase.swift
////  CopyPasteTests
////
////  Created by Garric Nahapetian on 1/27/18.
////  Copyright © 2018 SwiftCoders. All rights reserved.
////
//
//@testable import CopyPaste
//
//import XCTest
//
//class AppFlowTestCase: XCTestCase {
//
//    func test_DidFinish_Returns_True() {
//        let window = UIWindow()
//        let appFlow = AppFlow(window: window)
//        let launch = AppFlow.Launch(options: nil)
//        XCTAssertEqual(appFlow.didFinish(launch), true)
//    }
//
//    func test_Window_Given_Fresh_Install_Launch() {
//        let appFlow = AppFlow(window: UIWindow())
//        let launch = AppFlow.Launch(options: nil)
//        _ = appFlow.didFinish(launch)
//        XCTAssertNotNil(appFlow.window)
//        XCTAssertNotNil(appFlow.window?.rootViewController)
//    }
//
//    func test_Window_Given_ApplicationShortcutItem() {
//        let appFlow = AppFlow(window: UIWindow())
//        let item = UIApplicationShortcutItem(type: Globals.ShortcutItemTypes.newItem, localizedTitle: "")
//        let options = [UIApplicationLaunchOptionsKey.shortcutItem: item]
//        let launch = AppFlow.Launch(options: options)
//        _ = appFlow.didFinish(launch)
//        XCTAssertNotNil(appFlow.window)
//        XCTAssertNotNil(appFlow.window?.rootViewController)
//    }
//
//    func test_Perform_Action_For_ShortcutItem() {
//        let appFlow = AppFlow(window: UIWindow())
//        let launch = AppFlow.Launch(options: nil)
//        _ = appFlow.didFinish(launch)
//
//        let item = UIApplicationShortcutItem(type: Globals.ShortcutItemTypes.newItem, localizedTitle: "")
//        XCTAssertTrue(appFlow.performAction(for: item, completion: { _ in }))
//    }
//}

