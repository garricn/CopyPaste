//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class ForegroundFlow {

    let rootViewController: AppViewController = .init()

    private lazy var copyFlow: CopyFlow = .init()

    func didFinish(_ launch: Launch) -> Bool {
        let defaults = Defaults()
        let presenter = rootViewController

        func startWelcomeFlow(completion: (() -> Void)?) {
            let view = WelcomeViewController()
            presenter.present(view, animated: true, completion: nil)
            view.onDidTapGetStarted {
                completion?()

                view.dismiss(animated: true) {
                    defaults.shouldShowWelcomeScreen = false
                }
            }
        }

        switch launch.state {
        case .session:
            copyFlow.start(with: rootViewController)
        case .welcome:
            startWelcomeFlow {
                self.copyFlow.start(with: self.rootViewController)
            }
        }

        return true
    }
}

final class BackgroundFlow {
    func didFinish(_ launch: Launch) -> Bool { return false }
}
