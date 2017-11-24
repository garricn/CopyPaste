//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

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
}
