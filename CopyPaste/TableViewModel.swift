//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewModel {

    private let items: [Item]

    init(items: [Item] = []) {
        self.items = items
    }

    var isEditButtonEnabled: Bool {
        return !items.isEmpty
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
}
