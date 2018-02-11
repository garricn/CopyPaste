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

    private let cellIdentifier: String = UITableViewCell.identifier

    var numberOfSections: Int { return 1 }

    func numberOfRows(inSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    func cell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let cell = dequeuedCell ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let item = items.isEmpty ? Item(body: "Add Item") : items[indexPath.row]
        cell.textLabel?.text = item.body
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = item.copyCount.description
        cell.accessoryType = items.isEmpty ? .none : .detailDisclosureButton
        return cell
    }

    func editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return items.isEmpty ? .none : .delete
    }

    func canEditRow(at indexPath: IndexPath) -> Bool {
        return !items.isEmpty
    }
}
