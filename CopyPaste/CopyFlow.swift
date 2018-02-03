//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class CopyFlow {

    private(set) lazy var rootViewController: UINavigationController = {
        let viewController = TableViewController(viewModel: TableViewModel(items: items))
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    private let pasteboard: PasteboardProtocol = UIPasteboard.general
    private let context: CopyContext

    private var items: [Item] = [] {
        didSet {
            context.save(items)
            inputView.viewModel = TableViewModel(items: items)
        }
    }

    private var inputView: TableViewController {
        return rootViewController.topViewController as! TableViewController
    }

    init(context: CopyContext = CopyContext()) {
        self.context = context
        items = context.items
    }

    @discardableResult
    func didStart(with parent: UIViewController, reason: Launch.Reason = .normal) -> Bool {
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
            let newItem = Item(body: item.body, copyCount: (item.copyCount ?? 0) + 1)
            self.items.remove(at: row)
            self.items.insert(newItem, at: row)

            // Copy body to pasteboard
            self.pasteboard.string = newItem.body
        }

        inputView.onDidTapAccessoryButtonForRow { [weak self] indexPath, _ in
            self?.presentEditItemViewController(for: self?.items.element(at: indexPath.row), at: indexPath)
        }

        inputView.onDidCommitEditing { [weak self] edit, indexPath, _ in
            if case .delete = edit {
                self?.items.remove(at: indexPath.row)
            }
        }

        switch reason {
        case .normal:
            return true
        case let .shortcut(item):
            performAction(for: item)
            return false
        }
    }

    func performAction(for shortcutItem: ShortcutItem) {
        switch shortcutItem {
        case let .newItem(completion):
            presentEditItemViewController(for: nil, at: nil, completion: completion)
        }
    }

    private func presentEditItemViewController(for item: Item? = nil,
                                               at indexPath: IndexPath? = nil,
                                               completion: ((Bool) -> Void)? = nil) {

        let action = Action(item: item, indexPath: indexPath)
        let inputView = EditItemViewController(action: action)
        let containerView = UINavigationController(rootViewController: inputView)
        containerView.navigationBar.prefersLargeTitles = true
        rootViewController.present(containerView, animated: true, completion: nil)

        inputView.onDidTapCancelWhileEditing { [weak self] item, view in
            self?.rootViewController.dismiss(animated: true, completion: nil)
        }

        inputView.onDidTapSaveWhileEditing { [weak self] item, view in
            self?.rootViewController.dismiss(animated: true, completion: nil)

            switch action {
            case let .editing(_, indexPath):
                self?.items[indexPath.row] = item
            case .adding:
                self?.items.append(item)
            }
        }
        completion?(true)
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        if isEmpty || index > count {
            return nil
        } else {
            return self[index]
        }
    }
}
