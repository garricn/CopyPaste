//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

protocol TableViewModelingDelegate: class {
    func didLongPress(on item: Item, in viewModel: TableViewModeling)
    func didTapAddItem(in viewModel: TableViewModeling)
    func didCopy(item: Item, in viewModel: TableViewModeling)
}

protocol TableViewModeling: class {

    // Outputs
    var isEditButtonEnabled: ((Bool) -> Void)? { get set }
    var reloadRowsAtIndexPaths: (([IndexPath]) -> Void)? { get set }
    var insertRowsAtIndexPaths: (([IndexPath]) -> Void)? { get set }

    // Inputs
    var numberOfSections: Int { get }
    func viewDidLoad()
    func numberOfRows(inSection section: Int) -> Int
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> TableViewCell
    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView)
    func didLongPressRow(at indexPath: IndexPath, in tableView: UITableView)
    func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, in viewController: UITableViewController)
    func editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle
    func canEditRow(at indexPath: IndexPath) -> Bool
}

protocol TableViewModelConfigurable: class {
    weak var delegate: TableViewModelingDelegate? { get set }
    func configureWithEdited(item: Item)
    func configureWithCanceled(item: Item)
}


final class TableViewModel: TableViewModeling, TableViewModelConfigurable {

    weak var delegate: TableViewModelingDelegate?

    private var items: [Item] = [] {
        didSet {
            let objects = items.map(toItemObject)
            if ItemObject.archive(objects) {
                print("")
            } else {
                print("error")
            }

            isEditButtonEnabled?(!items.isEmpty)
        }
    }

    private var selectedIndexPath: IndexPath?

    init(items: [Item]) {
        self.items = items
    }

    // MARK: - TableViewModeling

    // MARK: - Outputs

    var isEditButtonEnabled: ((Bool) -> Void)?

    var reloadRowsAtIndexPaths: (([IndexPath]) -> Void)?

    var insertRowsAtIndexPaths: (([IndexPath]) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        isEditButtonEnabled?(!items.isEmpty)
    }

    var numberOfSections: Int { return 1 }

    func numberOfRows(inSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> TableViewCell {
        let identifier = TableViewCell.identifier
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let cell = dequeuedCell as? TableViewCell ?? TableViewCell()
        let index = indexPath.row

        let bodyText: String

        if items.isEmpty {
            bodyText = "Add Item"
        } else {
            let item = items[index]
            bodyText = item.body
            cell.accessibilityHint = "Copies content of Item."
        }

        cell.bodyText = bodyText
        return cell
    }

    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedIndexPath = indexPath

        if items.isEmpty {
            delegate?.didTapAddItem(in: self)
        } else {
            let index = indexPath.row
            let item = items[indexPath.row]

            // Increment copy count
            let newItem = Item(body: item.body, copyCount: item.copyCount + 1)
            items.remove(at: index)
            items.insert(newItem, at: index)
            tableView.reloadRows(at: [indexPath], with: .automatic)

            // Copy body to pasteboard
            UIPasteboard.general.string = newItem.body

            // Alert user to successful copy
            delegate?.didCopy(item: newItem, in: self)
            selectedIndexPath = nil
        }
    }

    func didLongPressRow(at indexPath: IndexPath, in tableView: UITableView) {
        selectedIndexPath = indexPath

        let item: Item

        if items.isEmpty {
            item = Item()
        } else {
            item = items[indexPath.row]
        }

        delegate?.didLongPress(on: item, in: self)
    }

    func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath, in viewController: UITableViewController) {
        guard edit == .delete, !items.isEmpty else {
            return
        }

        items.remove(at: indexPath.row)

        if items.isEmpty {
            viewController.tableView.reloadRows(at: [indexPath], with: .left)
            viewController.setEditing(false, animated: true)
        } else {
            viewController.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let style: UITableViewCellEditingStyle

        if items.isEmpty && indexPath.row == 0 {
            style = .none
        } else {
            style = .delete
        }

        return style
    }

    func canEditRow(at indexPath: IndexPath) -> Bool {
        return !(items.isEmpty && indexPath.row == 0)
    }

    // MARK: - TableViewModelConfigurable

    func configureWithCanceled(item: Item) {
         selectedIndexPath = nil
    }

    func configureWithEdited(item: Item) {
        if let selectedIndexPath = self.selectedIndexPath {

            if self.items.isEmpty {
                self.items.append(item)
            } else {
                self.items[selectedIndexPath.row] = item
            }

            reloadRowsAtIndexPaths?([selectedIndexPath])
            self.selectedIndexPath = nil

        } else {
            self.items.append(item)

            let indexPath = IndexPath(row: self.items.count - 1, section: 0)

            if self.items.count == 1 {
                reloadRowsAtIndexPaths?([indexPath])
            } else {
                insertRowsAtIndexPaths?([indexPath])
            }
        }
    }
}
