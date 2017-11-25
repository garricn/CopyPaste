//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {

    var viewModel: TableViewModel {
        didSet {
            didSetViewModel()
        }
    }

    private let tableView: TableView

    private var didTap: ((UIBarButtonItem) -> Void)?
    private var didSelectRow: ((IndexPath, UITableView) -> Void)?
    private var didLongPressRow: ((IndexPath, UITableView) -> Void)?
    private var didCommitEditing: ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)?

    // MARK: - Life Cycle

    init(viewModel: TableViewModel, tableView: TableView) {
        self.viewModel = viewModel
        self.tableView = tableView
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

        configureNavigationItems()
        configureTableView()
        didSetViewModel()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func onDidTapAddBarButtonItem(perform action: @escaping ((UIBarButtonItem) -> Void)) {
        didTap = action
    }
    
    func onDidSelectRow(perform action: @escaping ((IndexPath, UITableView) -> Void)) {
        didSelectRow = action
    }
    
    func onDidLongPress(perform action: @escaping ((IndexPath, UITableView) -> Void)) {
        didLongPressRow = action
    }
    
    func onDidCommitEditing(perform action: @escaping ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)) {
        didCommitEditing = action
    }

    private func configureNavigationItems() {
        let addAction = #selector(didTap(addBarButtonItem:))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.accessibilityLabel = "Add Item"
        navigationItem.title = "All Items"
        
    }

    private func configureTableView() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didLongPress))
        tableView.addGestureRecognizer(gestureRecognizer)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func didSetViewModel() {
        tableView.reloadData()
        setEditing(false, animated: true)
        editButtonItem.isEnabled = viewModel.isEditButtonEnabled
    }

    @objc private func didTap(addBarButtonItem: UIBarButtonItem) {
        self.didTap?(addBarButtonItem)
    }

    @objc private func didLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: sender.view)
        let tableView = sender.view as? UITableView
        let indexPath = tableView?.indexPathForRow(at: point)

        guard let table = tableView, let index = indexPath, sender.state == .began else {
            return
        }

        didLongPressRow?(index, table)
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
        didSelectRow?(indexPath, tableView)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        didCommitEditing?(editingStyle, indexPath, tableView)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return viewModel.editingStyleForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRow(at: indexPath)
    }
}
