//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import SafariServices
import UIKit

// TODO: - Rename to SessionFlow

public final class CopyFlow {

    private(set) lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: inputView)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    private let pasteboard: UIPasteboard = .general
    private let context: DataContext<[Item]> = AppContext.shared.itemsContext

    private(set) var items: [Item] = [] {
        didSet {
            context.save(items)
            inputView.viewModel = TableViewModel(items: items)
        }
    }

    lazy var inputView: TableViewController = .init(viewModel: .init(items: items))

    public init() {
        items = context.data
    }

    #if DEBUG
    private lazy var debugFlow: DebugFlow = .init()
    #endif
    
    public func start(with parent: UIViewController, reason: AppFlow.Launch.Reason = .normal) {
        parent.add(rootViewController)

        inputView.onDidTapAddBarButtonItem { [weak self] _ in
            self?.presentEditItemViewController()
        }

        inputView.onDidSelectRow { [weak self] indexPath, tableView in
            tableView.deselectRow(at: indexPath, animated: true)

            guard let `self` = self else {
                return
            }

            guard !self.items.isEmpty else {
                self.presentEditItemViewController()
                return
            }

            // Increment copy count
            let row = indexPath.row
            let item = self.items[row]
            let newItem = Item(body: item.body, copyCount: item.copyCount + 1, title: item.title)
            self.items.remove(at: row)
            self.items.insert(newItem, at: row)

            // Copy body to pasteboard
            self.pasteboard.string = newItem.body
        }

        inputView.onDidTapAccessoryButtonForRow { [weak self] indexPath, _ in
            guard let `self` = self, let item = self.items.element(at: indexPath.row) else {
                return
            }

            self.presentEditItemViewController(action: .editing(item, indexPath))
        }

        inputView.onDidCommitEditing { [weak self] edit, indexPath, _ in
            if case .delete = edit {
                self?.items.remove(at: indexPath.row)
            }
        }
        
        inputView.onDidLongPress { [weak self] indexPath, _ in
            guard let presenter = self?.inputView, let item = self?.items.element(at: indexPath.row) else {
                return
            }

            self?.startActionFlowIfNeeded(presenter: presenter, item: item)
        }
        
        #if DEBUG
        inputView.onDebugDidTap { [weak self] in
            guard let `self` = self else {
                return
            }
            self.debugFlow.start(presenter: self.rootViewController)
        }
        #endif

        switch reason {
        case .normal:
            break
        case let .shortcut(item):
            performAction(for: item)
        }
    }

    public func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case let .newItem(completion):
            presentEditItemViewController(completion: completion)
        }
    }
    
    private func startActionFlowIfNeeded(presenter: UIViewController, item: Item) {
        guard let url = item.urls.first else {
            return
        }

        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .overFullScreen
        presenter.present(viewController, animated: true, completion: nil)

    }

    private func presentEditItemViewController(action: Action = .adding,
                                               completion: ((Bool) -> Void)? = nil) {
        let viewModel = EditViewModel(title: action.item.title, body: action.item.body)
        let inputView = EditViewController(viewModel: viewModel)
        inputView.title = action.title

        let navigationController = UINavigationController(rootViewController: inputView)
        navigationController.navigationBar.prefersLargeTitles = true

        inputView.onDidTapCancelWhileEditing { [weak self] in
            self?.rootViewController.dismiss(animated: true, completion: nil)
        }

        inputView.onDidTapSaveWhileEditing { [weak self] editedItem in
            defer {
                self?.rootViewController.dismiss(animated: true)
            }

            guard let body = editedItem.body, !body.isEmpty else {
                return
            }

            guard case let .editing(existingItem, indexPath) = action else {
                self?.items.append(Item(body: body, copyCount: 0, title: editedItem.title))
                return
            }

            self?.items[indexPath.row] = Item(body: body, copyCount: existingItem.copyCount, title: editedItem.title)
        }

        rootViewController.present(navigationController, animated: true) {
            completion?(true)
        }
    }

    public enum Action {
        case adding
        case editing(Item, IndexPath)
        
        public var title: String {
            switch self {
            case .adding:
                return "Add Item"
            case .editing:
                return "Edit Item"
            }
        }
        
        public var item: Item {
            switch self {
            case .adding:
                return Item()
            case .editing(let item, _):
                return item
            }
        }
    }
}

extension Item {
    var urls: [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingAllTypes)
        let range = NSRange(location: 0, length: body.count)
        let matches = detector?.matches(in: body, options: .init(rawValue: 0), range: range) ?? []
        return matches.compactMap { $0.url }
    }
}
