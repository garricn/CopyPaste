//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {

    private let tableView = TableView(frame: CGRect.zero, style: .plain)
    private let viewModel: TableViewModeling

    // MARK: - Life Cycle

    init(viewModel: TableViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureViewModel()
        viewModel.viewDidLoad() // Must be called after ViewModel configured
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didLongPress))
        tableView.addGestureRecognizer(gestureRecognizer)
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc private func didLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: sender.view)
        let tableView = sender.view as? UITableView
        let indexPath = tableView?.indexPathForRow(at: point)

        guard let index = indexPath, sender.state == .began else {
            return
        }

        viewModel.didLongPressRow(at: index)
    }

    private func configureViewModel() {
        viewModel.isEditButtonEnabled = { [weak self] isEnabled in
            self?.editButtonItem.isEnabled = isEnabled
        }

        viewModel.reloadRows = { [weak self] indexPaths, animationStyle in
            self?.tableView.reloadRows(at: indexPaths, with: animationStyle)
        }

        viewModel.insertRows = { [weak self] indexPaths, animationStyle in
            self?.tableView.insertRows(at: indexPaths, with: animationStyle)
        }

        viewModel.deleteRows = { [weak self] indexPaths, animationStyle in
            self?.tableView.deleteRows(at: indexPaths, with: animationStyle)
        }

        viewModel.deselectRow = { [weak self] indexPath, animated in
            self?.tableView.deselectRow(at: indexPath, animated: animated)
        }

        viewModel.setEditing = { [weak self] bool, animated in
            self?.setEditing(bool, animated: animated)
        }
    }
}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = viewModel.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return viewModel.configured(cell: cell, forRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.commit(edit: editingStyle, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return viewModel.editingStyleForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRow(at: indexPath)
    }
}
