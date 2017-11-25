//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppFlow {

    private let context: AppContext
    private var window: UIWindow?

    private lazy var copyFlow: CopyFlow? = .init()

    init(context: AppContext, window: UIWindow?) {
        self.context = context
        self.window = window
    }

    func didFinishLaunching() -> Bool {
        switch context.state {
        case .session:
            return didStartCopyFlow()
        }
    }

    private func didStartCopyFlow() -> Bool {
        setupWindowIfNeeded()
        copyFlow?.start(withParentViewController: window!.rootViewController!)
        return true
    }

    private func setupWindowIfNeeded() {
        guard window?.rootViewController == nil else {
            return
        }

        window = UIWindow()
        window?.rootViewController = AppViewController()
        window?.makeKeyAndVisible()
    }
}

final class AppViewController: UIViewController {}
