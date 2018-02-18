////
////  Copyright © 2017 SwiftCoders. All rights reserved.
////
//
//import UIKit
//
//public final class WindowFlow {
//
//    private(set) lazy var rootView: RootViewController = .init()
//    private(set) lazy var context: DefaultsContext = .init()
//    private(set) lazy var copyFlow: CopyFlow = .init()
//
//    public func start(for reason: AppFlow.Launch.Reason) {
//
//        switch context.defaults.showWelcome {
//        case false:
//            copyFlow.start(with: rootView, reason: reason)
//        case true:
//            let view = WelcomeViewController()
//            view.onDidTapGetStarted {
//                view.dismiss(animated: true) { [unowned self] in
//                    self.copyFlow.start(with: self.rootView, reason: reason)
//                    self.context.save(Defaults(showWelcome: false))
//                }
//            }
//            rootView.present(view, animated: true, completion: nil)
//        }
//    }
//
//    public func performAction(for shortcutItem: ShortcutItem) {
//        switch shortcutItem {
//        case .newItem:
//            copyFlow.performAction(for: shortcutItem)
//        }
//    }
//}
//
//public extension WindowFlow {
//
//    public final class RootViewController: UIViewController {
//
//        fileprivate init() {
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required public init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        public override func viewDidLoad() {
//            super.viewDidLoad()
//            view.backgroundColor = .white
//        }
//    }
//}

