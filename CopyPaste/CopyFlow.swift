//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

// TODO: - Rename to SessionFlow

public final class CopyFlow {

    private(set) lazy var rootViewController: UINavigationController = {
        let viewController = TableViewController(viewModel: TableViewModel(items: items))
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    private let pasteboard: UIPasteboard = .general
    private let context: CopyContext<Item>

    private var items: [Item] = [] {
        didSet {
            context.save(items)
            inputView.viewModel = TableViewModel(items: items)
        }
    }

    private var inputView: TableViewController {
        return rootViewController.topViewController as! TableViewController
    }

    public init(context: CopyContext<Item> = .init()) {
        self.context = context
        items = context.items
    }

    public func start(with parent: UIViewController, reason: AppFlow.Launch.Reason = .normal) {
        parent.add(rootViewController)

        #if DEBUG
        inputView.onDebugDidTap { [weak self] in
            guard let `self` = self else {
                return
            }
            self.rootViewController.present(self.makeDebugAlertController(), animated: true)
        }
        #endif

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
            let newItem = Item(body: item.body, copyCount: item.copyCount + 1)
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

    #if DEBUG
    private func makeDebugAlertController() -> UIAlertController {
            let alert = UIAlertController(title: "RESET", message: nil, preferredStyle: .actionSheet)
            
            let dataTitle = "Data"
            let dataHandler: (UIAlertAction) -> Void  = { _ in CopyContext<Item>().reset() }
            let dataAction = UIAlertAction(title: dataTitle, style: .destructive, handler: dataHandler)
            dataAction.accessibilityLabel = Globals.UITestingResetAction.data
            alert.addAction(dataAction)
            
            let defaultsTitle = "Defaults"
            let defaultsHandler: (UIAlertAction) -> Void  = { _ in DefaultsContext().reset() }
            let defaultsAction = UIAlertAction(title: defaultsTitle, style: .destructive, handler: defaultsHandler)
            defaultsAction.accessibilityLabel = Globals.UITestingResetAction.defaults
            alert.addAction(defaultsAction)
            
            let bothTitle = "Both"
            let bothHandler: (UIAlertAction) -> Void  = { _ in CopyContext<Item>().reset(); DefaultsContext().reset() }
            let bothAction = UIAlertAction(title: bothTitle, style: .destructive, handler: bothHandler)
            bothAction.accessibilityLabel = Globals.UITestingResetAction.dataAndDefaults
            alert.addAction(bothAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            cancelAction.accessibilityLabel = Globals.UITestingResetAction.cancel
            alert.addAction(cancelAction)
            
            return alert
    }
    #endif

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

