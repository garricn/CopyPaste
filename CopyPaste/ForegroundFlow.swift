//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public final class ForegroundFlow {

    lazy var rootView: RootViewController = .init()
    lazy var context: DataContext<Defaults> = AppContext.shared.defaultsContext
    lazy var copyFlow: CopyFlow = .init()

    public func start(for reason: AppFlow.Launch.Reason) {
        switch context.data.showWelcome {
        case false:
            copyFlow.start(with: rootView, reason: reason)
        case true:
            let view = WelcomeViewController()
            view.onDidTapGetStarted { [weak self] in
                guard let `self` = self else {
                    return
                }

                view.dismiss(animated: true)
                self.copyFlow.start(with: self.rootView, reason: reason)
                self.context.save(Defaults(showWelcome: false))
            }
            rootView.present(view, animated: true, completion: nil)
        }
    }

    public func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case .newItem:
            copyFlow.performAction(for: shortcutItem)
        }
    }
}

public extension ForegroundFlow {

    public final class RootViewController: UIViewController {

        fileprivate init() {
            super.init(nibName: nil, bundle: nil)
        }

        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
        }
    }
}
