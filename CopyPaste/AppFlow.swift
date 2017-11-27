//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppFlow {

    private enum Kind {
        case foreground
    }

    private enum Reason {
        case normal
        var kind: Kind { return .foreground }
        init(launchOptions: LaunchOptions?) {
            if launchOptions == nil {
                self = .normal
            } else {
                fatalError()
            }
        }
    }

    private enum State {
        case welcome
        case session
    }

    private struct Launch {
        let kind: Kind
        let reason: Reason
        let state: State

        init(launchOptions: LaunchOptions?, defaults: Defaults) {
            self.reason = Reason(launchOptions: launchOptions)
            self.kind = reason.kind
            self.state = defaults.shouldShowWelcomeScreen ? .welcome : .session
        }
    }

    private var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func didFinishLaunching(_: UIApplication, _ launchOptions: LaunchOptions?) -> Bool {
        let defaults: Defaults = .init()
        let launch: Launch = .init(launchOptions: launchOptions, defaults: defaults)

        window = launch.kind == .foreground ? UIWindow() : nil
        window?.rootViewController = AppViewController()
        window?.makeKeyAndVisible()

        let presenter: UIViewController? = window?.rootViewController

        func startCopyFlow() {
            let location = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataStore = DataStore(encoder: JSONEncoder(), decoder: JSONDecoder(), location: location)
            let shouldResetItems = defaults.shouldResetUserDefaults
            let context = CopyContext(dataStore: dataStore, shouldResetItems: shouldResetItems)
            let flow = CopyFlow(context: context)
            flow.start(with: presenter!)
        }

        func startWelcomeFlow(completion: (() -> Void)?) {
            let view = WelcomeViewController()
            presenter?.present(view, animated: true, completion: nil)
            view.onDidTapGetStarted {
                completion?()

                view.dismiss(animated: true) {
                    defaults.shouldShowWelcomeScreen = false
                }
            }
        }

        switch launch.state {
        case .session:
            startCopyFlow()
        case .welcome:
            startWelcomeFlow(completion: startCopyFlow)
        }

        return true
    }
}
