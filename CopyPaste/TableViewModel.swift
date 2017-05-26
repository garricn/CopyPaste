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
    var reloadRows: (([IndexPath], UITableViewRowAnimation) -> Void)? { get set }
    var insertRows: (([IndexPath], UITableViewRowAnimation) -> Void)? { get set }
    var deleteRows: (([IndexPath], UITableViewRowAnimation) -> Void)? { get set }
    var deselectRow: ((IndexPath, Bool) -> Void)? { get set }
    var setEditing: ((Bool, Bool) -> Void)? { get set }

    // Inputs
    var cellIdentifier: String { get }
    var numberOfSections: Int { get }
    func viewDidLoad()
    func numberOfRows(inSection section: Int) -> Int
    func configured(cell: UITableViewCell, forRowAt indexPath: IndexPath) -> TableViewCell
    func didSelectRow(at indexPath: IndexPath)
    func didLongPressRow(at indexPath: IndexPath)
    func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
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

    private var items: [Item] {
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

    private let pasteboard: PasteboardProtocol
    private var selectedIndexPath: IndexPath?

    init(items: [Item] = [], pasteboard: PasteboardProtocol = UIPasteboard.general) {
        self.items = items
        self.pasteboard = pasteboard
    }

    // MARK: - TableViewModeling

    var isEditButtonEnabled: ((Bool) -> Void)?

    var reloadRows: (([IndexPath], UITableViewRowAnimation) -> Void)?

    var insertRows: (([IndexPath], UITableViewRowAnimation) -> Void)?

    var deleteRows: (([IndexPath], UITableViewRowAnimation) -> Void)?

    var deselectRow: ((IndexPath, Bool) -> Void)?

    var setEditing: ((Bool, Bool) -> Void)?

    func viewDidLoad() {
        isEditButtonEnabled?(!items.isEmpty)
    }

    var cellIdentifier: String { return TableViewCell.identifier }

    var numberOfSections: Int { return 1 }

    func numberOfRows(inSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    func configured(cell: UITableViewCell, forRowAt indexPath: IndexPath) -> TableViewCell {
        guard let _cell = cell as? TableViewCell else {
            fatalError("Expects a TableViewCell")
        }

        let index = indexPath.row

        let bodyText: String

        if items.isEmpty {
            bodyText = "Add Item"
        } else {
            let item = items[index]
            bodyText = item.body
            _cell.accessibilityHint = "Copies content of Item."
        }

        _cell.bodyText = bodyText
        return _cell
    }

    func didSelectRow(at indexPath: IndexPath) {
        deselectRow?(indexPath, true)

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

            // Copy body to pasteboard
            pasteboard.string = newItem.body

            // Alert user to successful copy
            delegate?.didCopy(item: newItem, in: self)
            selectedIndexPath = nil
        }
    }

    func didLongPressRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath

        if items.isEmpty {
            delegate?.didTapAddItem(in: self)
        } else {
            let item = items[indexPath.row]
            delegate?.didLongPress(on: item, in: self)
        }
    }

    func commit(edit: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard edit == .delete, !items.isEmpty else {
            return
        }

        items.remove(at: indexPath.row)

        if items.isEmpty {
            reloadRows?([indexPath], .left)
            setEditing?(false, true)
        } else {
            deleteRows?([indexPath], .automatic)
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
        if let indexPath = selectedIndexPath {

            if items.isEmpty {
                items.append(item)
            } else {
                items[indexPath.row] = item
            }

            reloadRows?([indexPath], .automatic)
            self.selectedIndexPath = nil

        } else {
            items.append(item)

            let indexPath = IndexPath(row: self.items.count - 1, section: 0)

            if items.count == 1 {
                reloadRows?([indexPath], .automatic)
            } else {
                insertRows?([indexPath], .automatic)
            }
        }
    }
}


