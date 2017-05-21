//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableView: UITableView {

    var onLongPress: ((TableView, IndexPath) -> Void)?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didLongPress))

        addGestureRecognizer(gestureRecognizer)
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100
        backgroundColor = .lightGray
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }

        let point = sender.location(in: sender.view)

        if let indexPath = indexPathForRow(at: point) {
            onLongPress?(self, indexPath)
        }
    }
}
