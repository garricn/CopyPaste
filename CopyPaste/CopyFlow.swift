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
        parent.add(rootViewController)

        func presentAddItemViewController() {
            let viewController = AddItemViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            rootViewController.present(navigationController, animated: true, completion: nil)

            viewController.onDidTapCancelWhileEditing { item, viewController in
                viewController.dismiss(animated: true, completion: nil)
            }

            viewController.onDidTapSaveWhileEditing { item, viewController in
                viewController.dismiss(animated: true, completion: nil)

                guard !item.body.isEmpty else {
                    return
                }

                items.append(item)
            }
        }

        tableViewController.onDidTapAddBarButtonItem { _ in
            presentAddItemViewController()
        }

        tableViewController.onDidSelectRow { [weak self] indexPath, tableView in
            tableView.deselectRow(at: indexPath, animated: true)

            guard !items.isEmpty else {
                presentAddItemViewController()
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

            // Alert user to successful copy
            let alert = UIAlertController(title: nil, message: "Item Copied to Pasteboard.", preferredStyle: .alert)
            alert.accessibilityLabel = "Copy successful"
            rootViewController.present(alert, animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let alert = rootViewController.presentedViewController as? UIAlertController else {
                    return
                }

                alert.dismiss(animated: true, completion: nil)
            }
        }

        tableViewController.onDidLongPress { indexPath, tableView in
            guard !items.isEmpty else {
                presentAddItemViewController()
                return
            }

            let editViewController = EditItemViewController(itemToEdit: items[indexPath.row])
            let navigationController = UINavigationController(rootViewController: editViewController)
            rootViewController.present(navigationController, animated: true, completion: nil)

            editViewController.onDidTapCancelWhileEditing { _, viewController in
                viewController.dismiss(animated: true, completion: nil)
            }

            editViewController.onDidTapSaveWhileEditing { item, viewController in
                viewController.dismiss(animated: true, completion: nil)

                guard !item.body.isEmpty else {
                    return
                }

                if items.isEmpty {
                    items.append(item)
                } else {
                    items[indexPath.row] = item
                }
            }
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
