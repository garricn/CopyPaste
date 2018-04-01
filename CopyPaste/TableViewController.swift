//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public final class TableViewController: UIViewController {

    public var viewModel: TableViewModel {
        didSet {
            didSetViewModel()
        }
    }

    private let tableView: UITableView

    private var debugDidTap: (() -> Void)?
    private var didTap: ((UIBarButtonItem) -> Void)?
    private var didSelectRow: ((IndexPath, UITableView) -> Void)?
    private var didCommitEditing: ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)?
    private var didTapAccessoryButtonForRow: ((IndexPath, UITableView) -> Void)?

    // MARK: - Life Cycle

    public init(tableView: UITableView = .init(), viewModel: TableViewModel = .init()) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    public override func loadView() {
        view = tableView
    }

    public override func viewDidLoad() {
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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if navigationItem.searchController == nil {
            navigationItem.searchController = searchController
        }
    }

    public override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    public func onDebugDidTap(perform action: @escaping (() -> Void)) {
        debugDidTap = action
    }

    public func onDidTapAddBarButtonItem(perform action: @escaping ((UIBarButtonItem) -> Void)) {
        didTap = action
    }
    
    public func onDidSelectRow(perform action: @escaping ((IndexPath, UITableView) -> Void)) {
        didSelectRow = action
    }

    public func onDidCommitEditing(perform action: @escaping ((UITableViewCellEditingStyle, IndexPath, UITableView) -> Void)) {
        didCommitEditing = action
    }

    public func onDidTapAccessoryButtonForRow(perform action: @escaping ((IndexPath, UITableView) -> Void)) {
        didTapAccessoryButtonForRow = action
    }

    private func configureNavigationItems() {
        navigationItem.title = "All Items"
        navigationItem.rightBarButtonItem = editButtonItem

        var items: [UIBarButtonItem] = []
        let addAction = #selector(didTap(addBarButtonItem:))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        addButton.accessibilityLabel = "Add Item"
        items.append(addButton)

        #if DEBUG
            let debugAction = #selector(didTap(debugBarButtonItem:))
            let debugButton = UIBarButtonItem(title: "⚙︎", style: .plain, target: self, action: debugAction)
            debugButton.accessibilityLabel = "debug"
            items.append(debugButton)
        #endif

        navigationItem.leftBarButtonItems = items
    }

    #if DEBUG
    @objc
    private func didTap(debugBarButtonItem: UIBarButtonItem) {
        debugDidTap?()
    }
    #endif

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

    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(forRowAt: indexPath, in: tableView)
    }
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(indexPath, tableView)
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        didCommitEditing?(editingStyle, indexPath, tableView)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return viewModel.editingStyleForRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRow(at: indexPath)
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        didTapAccessoryButtonForRow?(indexPath, tableView)
    }
}

extension TableViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}
