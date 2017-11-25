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

    private lazy var subFlows: [Flow] = [copyFlow].flatMap { $0 }

    private lazy var copyFlow: Flow? = {
        let location = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataStore = DataStore(encoder: JSONEncoder(), decoder: JSONDecoder(), location: location)
        let context = CopyContext(dataStore: dataStore, shouldResetItems: CommandLine.arguments.contains("reset"))
        return CopyFlow(context: context)
    }()

    private var rootViewController: UIViewController {
        return window!.rootViewController!
    }

    init(context: AppContext, window: UIWindow?) {
        self.context = context
        self.window = window
    }

    func didFinishLaunching() -> Bool {
        setupWindowIfNeeded()

        switch context.state {
        case .welcome:
            return didStartWelcomeFlow()
        case .session:
            return didStartCopyFlow()
        }
    }

    func applicationWillTerminate() {
        subFlows.forEach { $0.applicationWillTerminate() }
    }

    private func didStartWelcomeFlow() -> Bool {
        let welcomeViewController = WelcomeViewController()
        rootViewController.present(welcomeViewController, animated: true, completion: nil)
        welcomeViewController.onDidTapGetStarted { [weak self] in
            self?.didStartCopyFlow()

            welcomeViewController.dismiss(animated: true) {
                self?.context.didViewWelcomeScreen()
            }
        }
        return true
    }

    @discardableResult
    private func didStartCopyFlow() -> Bool {
        copyFlow?.start(with: rootViewController)
        return true
    }

    private func setupWindowIfNeeded() {
        guard window?.rootViewController == nil, context.isForegroundLaunch else {
            return
        }

        window = UIWindow()
        window?.rootViewController = AppViewController()
        window?.makeKeyAndVisible()
    }
}
