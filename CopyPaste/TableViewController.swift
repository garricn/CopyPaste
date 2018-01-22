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

    private let tableView: UITableView = .init()

    private var didTap: ((UIBarButtonItem) -> Void)?
    private var didSelectRow: ((IndexPath, UITableView) -> Void)?
    private var didCommitEditing: ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)?
    private var didTapAccessoryButtonForRow: ((IndexPath, UITableView) -> Void)?

    // MARK: - Life Cycle

    init(viewModel: TableViewModel = TableViewModel()) {
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
        configureNavigationItems()
        configureTableView()
        didSetViewModel()
    }

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        return controller
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if navigationItem.searchController == nil {
            navigationItem.searchController = searchController
        }
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

    func onDidCommitEditing(perform action: @escaping ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)) {
        didCommitEditing = action
    }

    func onDidTapAccessoryButtonForRow(perform action: @escaping ((IndexPath, UITableView) -> Void)) {
        didTapAccessoryButtonForRow = action
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
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
        return viewModel.cell(forRowAt: indexPath, in: tableView)
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

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        didTapAccessoryButtonForRow?(indexPath, tableView)
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}
