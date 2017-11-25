//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class CopyFlow: Flow {

    private let pasteboard: PasteboardProtocol = UIPasteboard.general
    private let context: CopyContext

    init(context: CopyContext) {
        self.context = context
    }

    func start(with parent: UIViewController) {
        let tableViewController: TableViewController

        var items: [Item] = context.items.sorted(by: copyCountDescending) {
            didSet {
                context.set(items: items)
                tableViewController.viewModel = TableViewModel(items: items)
            }
        }

        tableViewController = TableViewController(viewModel: TableViewModel(items: items), tableView: TableView())
        let rootViewController = UINavigationController(rootViewController: tableViewController)
        rootViewController.navigationBar.prefersLargeTitles = true
        parent.add(rootViewController)

        func presentEditItemViewController(for action: EditItemViewController.Action) {
            let viewController = EditItemViewController(action: action)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.prefersLargeTitles = true
            rootViewController.present(navigationController, animated: true, completion: nil)
            viewController.onDidTapCancelWhileEditing { item, viewController in
                viewController.dismiss(animated: true, completion: nil)
            }
            viewController.onDidTapSaveWhileEditing { item, viewController in
                viewController.dismiss(animated: true, completion: nil)
                guard case .editing(_, let indexPath) = action, !item.body.isEmpty, !items.isEmpty else {
                    items.append(item)
                    return
                }
                items[indexPath.row] = item
            }
        }

        tableViewController.onDidTapAddBarButtonItem { _ in
            presentEditItemViewController(for: .adding)
        }

        tableViewController.onDidSelectRow { [weak self] indexPath, tableView in
            tableView.deselectRow(at: indexPath, animated: true)

            guard !items.isEmpty else {
                presentEditItemViewController(for: .adding)
                return
            }

            // Increment copy count
            let row = indexPath.row
            let item = items[row]
            let newItem = Item(body: item.body, copyCount: item.copyCount + 1)
            items.remove(at: row)
            items.insert(newItem, at: row)

            // Copy body to pasteboard
            self?.pasteboard.string = newItem.body
        }

        tableViewController.onDidLongPress { indexPath, tableView in
            guard !items.isEmpty else {
                presentEditItemViewController(for: .adding)
                return
            }

            let item = items[indexPath.row]
            let editing: EditItemViewController.Action = .editing(item, at: indexPath)
            presentEditItemViewController(for: editing)
        }

        tableViewController.onDidCommitEditing { edit, indexPath, tableView in
            guard edit == .delete, !items.isEmpty else {
                return
            }

            items.remove(at: indexPath.row)
        }
    }

    func applicationWillTerminate() {
        context.saveItems()
    }
}
