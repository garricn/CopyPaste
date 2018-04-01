//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public final class TableViewModel {

    private let items: [Item]

    public init(items: [Item] = []) {
        self.items = items
    }

    public var isEditButtonEnabled: Bool {
        return !items.isEmpty
    }

    private let cellIdentifier: String = UITableViewCell.identifier

    public var numberOfSections: Int { return 1 }

    public func numberOfRows(inSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    public func cell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let cell = dequeuedCell ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)

        let item = items.isEmpty ? Item(body: "Add Item") : items[indexPath.row]

        if let title = item.title, !title.isEmpty {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.body
        } else {
            cell.textLabel?.text = item.body
            cell.detailTextLabel?.text = ""
        }

        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = items.isEmpty ? .none : .detailDisclosureButton
        return cell
    }

    public func editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return items.isEmpty ? .none : .delete
    }

    public func canEditRow(at indexPath: IndexPath) -> Bool {
        return !items.isEmpty
    }
}
