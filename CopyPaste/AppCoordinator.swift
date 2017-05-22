//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppCoordinator: TableViewModelingDelegate, EditViewControllerDelegate {
    let rootViewController: UINavigationController

    private let items: [Item]
    private let viewModel: TableViewModelConfigurable

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

    func didTapAddItem(in viewModel: TableViewModeling) {
        presentAddItemViewController()
    }

    func didLongPress(on item: Item, in viewModel: TableViewModeling) {
        presentAddItemViewController(title: "Edit Item", itemToEdit: item)
    }

    func didCopy(item: Item, in viewModel: TableViewModeling) {
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

    // MARK: - EditViewControllerDelegate

    func didCancelEditing(_ item: Item, in viewController: EditViewController) {
        viewModel.configureWithCanceled(item: item)
        rootViewController.dismiss(animated: true)
    }

    func didFinishEditing(_ item: Item, in viewController: EditViewController) {
        rootViewController.dismiss(animated: true) {
            self.viewModel.configureWithEdited(item: item)
        }
    }

    // MARK: - Private Functions

    @objc private func didTapAddBarButtonItem(sender: UIBarButtonItem) {
        presentAddItemViewController()
    }

    private func presentAddItemViewController(title: String = "Add Item", itemToEdit item: Item = Item()) {
        let viewController = EditViewController(itemToEdit: item)
        viewController.delegate = self
        viewController.navigationItem.title = title

        let navigationController = UINavigationController(rootViewController: viewController)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
}
