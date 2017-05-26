//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppCoordinator: TableViewModelingDelegate, EditItemViewControllerDelegate {
    let rootViewController: UINavigationController

    private let items: [Item]
    private let viewModel: TableViewModelConfigurable

    private var indexPath = IndexPath(row: 0, section: 0)

    init() {
        if CommandLine.arguments.contains("reset") {
            items = []
            ItemObject.archive([])
        } else {
            items = ItemObject.unarchived().map(toItem).sorted(by: copyCountDescending)
        }

        let viewModel = TableViewModel(items: items)
        let viewController = TableViewController(viewModel: viewModel)
        rootViewController = UINavigationController(rootViewController: viewController)

        self.viewModel = viewModel
        self.viewModel.delegate = self

        let addAction = #selector(didTapAddBarButtonItem)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        viewController.navigationItem.leftBarButtonItem = addButton
        viewController.navigationItem.leftBarButtonItem?.accessibilityLabel = "Add Item"
        viewController.navigationItem.rightBarButtonItem = viewController.editButtonItem
        viewController.editButtonItem.isEnabled = !items.isEmpty
        viewController.navigationItem.title = "All Items"
    }

    // MARK: - TableViewModelingDelegate

    func didTapAddItem() {
        presentAddItemViewController()
    }

    func didLongPress(on item: Item, at indexPath: IndexPath) {
        self.indexPath = indexPath

        let viewController = EditItemViewController(itemToEdit: item)
        viewController.delegate = self

        let navigationController = UINavigationController(rootViewController: viewController)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }

    func didCopy(item: Item) {
        let alert = UIAlertController(title: nil, message: "Item Copied to Pasteboard.", preferredStyle: .alert)
        alert.accessibilityLabel = "Copy successful"

        rootViewController.present(alert, animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let _ = self.rootViewController.presentedViewController as? UIAlertController {
                    self.rootViewController.dismiss(animated: true)
                }
            }
        }
    }

    // MARK: - EditItemViewControllerDelegate

    func didCancelEditing(_ item: Item, in viewController: EditItemViewController) {
        rootViewController.dismiss(animated: true)
    }

    func didFinishEditing(_ item: Item, in viewController: EditItemViewController) {
        rootViewController.dismiss(animated: true) {
            if let _ = viewController as? AddItemViewController {
                self.viewModel.configureWithAdded(item: item)
            } else {
                self.viewModel.configureWithEdited(item: item, at: self.indexPath)
            }
        }
    }

    // MARK: - Private Functions

    @objc private func didTapAddBarButtonItem(sender: UIBarButtonItem) {
        presentAddItemViewController()
    }

    private func presentAddItemViewController() {
        let viewController = AddItemViewController()
        viewController.delegate = self

        let navigationController = UINavigationController(rootViewController: viewController)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
}
