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

    public let provider: ForegroundDependencyProvider

    public init(provider: ForegroundDependencyProvider) {
        self.provider = provider
    }

    public func didStart(for reason: Launch.Reason) -> Bool {
        switch foregroundContext.defaults.showWelcome {
        case false:
            return didStartCopyFlow(reason: reason)
        case true:
            return didStartWelcomeFlow(didFinish: { [weak self] in
                self?.didStartCopyFlow(reason: reason)
            })
        }
    }

    public func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case .newItem:
            copyFlow.performAction(for: shortcutItem)
        }
    }
    
    @discardableResult
    private func didStartCopyFlow(reason: Launch.Reason) -> Bool {
        children = FlowType.children(for: [.copy(copyFlow)])
        return copyFlow.didStart(with: rootViewController, reason: reason)
    }
    
    private func didStartWelcomeFlow(didFinish: (() -> Void)?) -> Bool {
        let view = WelcomeViewController()

        children = FlowType.children(for: [FlowType.welcome(view)])
        
        rootViewController.present(view, animated: true, completion: nil)
        view.onDidTapGetStarted {
            didFinish?()
            
            view.dismiss(animated: true) { [weak self] in
                let defaults = Defaults(showWelcome: false)
                self?.foregroundContext.save(defaults)
                self?.children.removeValue(forKey: .welcome)
            }
        }
        return true
    }
}
