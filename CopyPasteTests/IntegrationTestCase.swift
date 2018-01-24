//
//  IntegrationTestCase.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 1/28/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste

import XCTest

class IntegrationTestCase: XCTestCase {

    func testFoo() {
        let parent = UIApplication.shared
        let identifier = "SpyAppFlow"
        let makeForegroundFlow = { ForegroundFlow.init() }
        let makeBackgroundFlow = { BackgroundFlow.init() }
        let window = UIWindow()

        
        let appFlow = AppFlow.init(parent: parent,
                                   identifier: identifier,
                                   makeForegroundFlow: makeForegroundFlow,
                                   makeBackgroundFlow: makeBackgroundFlow,
                                   window: window)

        let launch = Launch.init(options: nil)
        XCTAssertEqual(launch.kind, .foreground)
        XCTAssertTrue(launch.reason.isNormal)
        XCTAssertNil(launch.options)
        XCTAssertTrue(appFlow.willFinish(launch))
        XCTAssertNotNil(appFlow.window?.rootViewController)
        XCTAssertTrue(appFlow.window?.rootViewController is AppViewController)
        XCTAssertTrue(appFlow.didFinish(launch))

        let children = appFlow.didStartChildFlows(for: launch)
        XCTAssertEqual(children.count, 1)

        let child = appFlow.children[.foreground]
        XCTAssertNotNil(child)

        let foregroundFlow = child as! ForegroundFlow

        let childViewController = foregroundFlow.rootViewController.childViewControllers[0]
        XCTAssertTrue(childViewController is UINavigationController)
        let navigationController = childViewController as! UINavigationController
        let viewController = navigationController.viewControllers[0]
        XCTAssertTrue(viewController is TableViewController)
        let tableViewController = viewController as! TableViewController
        XCTAssertEqual(tableViewController.numberOfSections(in: UITableView()), 1)

        let flow = foregroundFlow.children[.copy]
        XCTAssertNotNil(flow)
        let copyFlow = flow as! CopyFlow
        XCTAssertTrue(copyFlow.rootViewController.viewControllers[0] == viewController)

//        let dataStore = DataStore()
//        let context = CopyContext(dataStore: dataStore)
    }
}
// they gave you $8000
// you +8000
// you spent - 4000 on your card
// you -4000
// they returned +1500
// you +1500
// you now at +5500
// +2500 spent (not returned)
// +5500 still in your account NEEDS TO BE RETURNED
// but +/- TAXES
// taxes when spent

// you spent total of $4000 (included taxes)
// they returned $1500 (includd taxes
// $2500 spent but not returned

