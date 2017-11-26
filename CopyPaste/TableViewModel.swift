//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewModel {

    private let items: [Item]

    init(items: [Item]) {
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
        guard let cell = cell as? TableViewCell else {
            fatalError("Expects a TableViewCell")
        }

        let item = items.isEmpty ? Item(body: "Add Item", copyCount: nil) : items[indexPath.row]
        cell.bodyText = item.body
        cell.countText = item.copyCount?.description
        return cell
    }

    func editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return items.isEmpty ? .none : .delete
    }

    func canEditRow(at indexPath: IndexPath) -> Bool {
        return !items.isEmpty
    }
}
