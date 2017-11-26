//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class CopyFlow {

    private let pasteboard: PasteboardProtocol = UIPasteboard.general
    private let context: CopyContext

    init(context: CopyContext) {
        self.context = context
    }

    func start(with parent: UIViewController) {
        let inputView: TableViewController

        var items: [Item] = context.items {
            didSet {
                context.save(items)
                inputView.viewModel = TableViewModel(items: items)
            }
        }

        inputView = TableViewController(viewModel: TableViewModel(items: items))
        let presenter = UINavigationController(rootViewController: inputView)
        presenter.navigationBar.prefersLargeTitles = true
        parent.add(presenter)

        func presentEditItemViewController(for item: Item? = nil, at indexPath: IndexPath? = nil) {
            let action = Action(item: item, indexPath: indexPath)
            let inputView = EditItemViewController(action: action)
            let containerView = UINavigationController(rootViewController: inputView)
            containerView.navigationBar.prefersLargeTitles = true
            presenter.present(containerView, animated: true, completion: nil)
            inputView.onDidTapCancelWhileEditing { item, view in
                view.dismiss(animated: true, completion: nil)
            }
            inputView.onDidTapSaveWhileEditing { item, view in
                view.dismiss(animated: true, completion: nil)
                guard case let .editing(_, indexPath) = action else {
                    items.append(item)
                    return
                }
                items[indexPath.row] = item
            }
        }

        inputView.onDidTapAddBarButtonItem { _ in
            presentEditItemViewController()
        }

        inputView.onDidSelectRow { [weak self] indexPath, tableView in
            tableView.deselectRow(at: indexPath, animated: true)

            guard !items.isEmpty else {
                presentEditItemViewController()
                return
            }

            // Increment copy count
            let row = indexPath.row
            let item = items[row]
            let newItem = Item(body: item.body, copyCount: (item.copyCount ?? 0) + 1)
            items.remove(at: row)
            items.insert(newItem, at: row)

            // Copy body to pasteboard
            self?.pasteboard.string = newItem.body
        }

        inputView.onDidTapAccessoryButtonForRow { indexPath, _ in
            presentEditItemViewController(for: items.isEmpty ? nil : items[indexPath.row], at: indexPath)
        }

        inputView.onDidCommitEditing { edit, indexPath, _ in
            if case .delete = edit {
                items.remove(at: indexPath.row)
            }
        }
    }

}
