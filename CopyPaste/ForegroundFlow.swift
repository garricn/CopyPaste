//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public protocol ForegroundDependencyProvider {
    var makeRootViewController: () -> AppViewController { get }
    var makeDefaultsContext: () -> DefaultsContext { get }
    var makeCopyFlow: () -> CopyFlow { get }
}

public final class ForegroundFlow: Flow {

    private(set) lazy var rootViewController: AppViewController = self.provider.makeRootViewController()
    private(set) lazy var foregroundContext: DefaultsContext = self.provider.makeDefaultsContext()
    private(set) lazy var copyFlow: CopyFlow = self.provider.makeCopyFlow()
    private(set) var children: [FlowType.FlowKey: Flow] = [:]

    let provider: ForegroundDependencyProvider

    init(provider: ForegroundDependencyProvider) {
        self.provider = provider
    }

    func didStart(for reason: Launch.Reason) -> Bool {
        func didStartWelcomeFlow(completion: (() -> Void)?) -> Bool {
            let view = WelcomeViewController()
            rootViewController.present(view, animated: true, completion: nil)
            view.onDidTapGetStarted {
                completion?()

                view.dismiss(animated: true) { [weak self] in
                    let defaults = Defaults(showWelcome: false)
                    self?.foregroundContext.save(defaults)
                }
            }
            return true
        }
        switch foregroundContext.defaults.showWelcome {
        case false:
            children = FlowType.children(for: [.copy(copyFlow)])
            return copyFlow.didStart(with: rootViewController, reason: reason)
        case true:
            return didStartWelcomeFlow {
                self.copyFlow.didStart(with: self.rootViewController, reason: reason)
            }
        }
    }

    public func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case .newItem:
            copyFlow.performAction(for: shortcutItem)
        }
    }
}
