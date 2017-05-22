//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewController: UITableViewController {

    private let myTableView = TableView(frame: CGRect.zero, style: .plain)
    private let viewModel: TableViewModeling


    // MARK: - Life Cycle

    init(viewModel: TableViewModeling) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func loadView() {
        tableView = myTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.didLongPressRow = { [weak self] indexPath, tableView in
            self?.viewModel.didLongPressRow(at: indexPath, in: tableView)
        }

        configureViewModel()
    }

    private func configureViewModel() {
        viewModel.isEditButtonEnabled = { [weak self] isEnabled in
            self?.editButtonItem.isEnabled = isEnabled
        }

        viewModel.reloadRowsAtIndexPaths = { [weak self] indexPaths in
            self?.tableView.reloadRows(at: indexPaths, with: .automatic)
        }

        viewModel.insertRowsAtIndexPaths = { [weak self] indexPaths in
            self?.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath, in: tableView)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath, in: tableView)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.commit(style: editingStyle, forRowAt: indexPath, in: self)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return viewModel.editingStyleForRow(at: indexPath)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRow(at: indexPath)
    }
}
