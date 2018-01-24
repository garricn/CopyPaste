//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class ForegroundFlow {

    let rootViewController: AppViewController = .init()

    private lazy var copyFlow: CopyFlow = .init()

    private let defaults: Defaults = .init()

    func didFinish(_ launch: Launch) -> Bool {
        func didStartWelcomeFlow(completion: (() -> Void)?) -> Bool {
            let view = WelcomeViewController()
            rootViewController.present(view, animated: true, completion: nil)
            view.onDidTapGetStarted {
                completion?()

                view.dismiss(animated: true) {
                    self.defaults.shouldShowWelcomeScreen = false
                }
            }
            return true
        }

        switch launch.state {
        case .session:
            return copyFlow.didStart(with: rootViewController, reason: launch.reason)
        case .welcome:
            return didStartWelcomeFlow {
                self.copyFlow.didStart(with: self.rootViewController, reason: launch.reason)
            }
        }
    }

    func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case .newItem:
            copyFlow.performAction(for: shortcutItem)
        }
    }
}
