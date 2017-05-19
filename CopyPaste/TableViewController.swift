//
//  TableViewController.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 4/5/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewController: UITableViewController, EditViewControllerDelegate {

    private var items: [Item] = [] {
        didSet {
            let objects = items.map(toItemObject)
            if ItemObject.archive(objects) {
                print("")
            } else {
                print("error")
            }

            navigationItem.rightBarButtonItem?.isEnabled = !items.isEmpty
        }
    }

    private var selectedIndexPath: IndexPath?
    private let cellIdentifier = TableViewCell.identifier

    // MARK: - Life Cycle

    init(items: [Item]) {
        self.items = items
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureTableView()
    }

    // MARK: - View Configuration

    private func configureNavigationItem() {
        let addAction = #selector(didTapAddBarButtonItem)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        navigationItem.leftBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.accessibilityLabel = "Add Item"
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.isEnabled = !items.isEmpty
        navigationItem.title = "All Items"
    }

    private func configureTableView() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didLongPress))

        tableView.addGestureRecognizer(gestureRecognizer)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell = dequeuedCell as? TableViewCell ?? TableViewCell()
        let index = indexPath.row

        let bodyText: String

        if items.isEmpty {
            bodyText = "Add Item"
        } else {
            let item = items[index]
            bodyText = item.body
            cell.accessibilityHint = "Copies content of Item."
        }

        cell.bodyText = bodyText
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedIndexPath = indexPath

        if items.isEmpty {
            presentEditViewController()
        } else {
            copyItem(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:
            items.remove(at: indexPath.row)

            if items.isEmpty {
                tableView.reloadRows(at: [indexPath], with: .left)
                setEditing(false, animated: true)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        case .insert:
            presentEditViewController()
        case .none: break
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let style: UITableViewCellEditingStyle

        if items.isEmpty && indexPath.row == 0 {
            style = .none
        } else {
            style = .delete
        }

        return style
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(items.isEmpty && indexPath.row == 0)
    }

    // MARK: - Private Functions

    private func copyItem(at indexPath: IndexPath) {
        let index = indexPath.row
        let item = items[indexPath.row]

        // Copy body to pasteboard
        UIPasteboard.general.string = item.body

        // Alert user to successful copy
        presentAlert()

        // Increment copy count
        let newItem = Item(body: item.body, copyCount: item.copyCount + 1)
        items.remove(at: index)
        items.insert(newItem, at: index)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func presentAlert() {
        let alert = UIAlertController(title: nil, message: "Item Copied to Pasteboard.", preferredStyle: .alert)
        alert.accessibilityLabel = "Copy successful"

        present(alert, animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let _ = self.presentedViewController as? UIAlertController {
                    self.dismiss(animated: true) {
                        self.selectedIndexPath = nil
                    }
                }
            }
        }
    }

    private func presentEditViewController(itemToEdit item: Item = Item()) {
        let viewController = EditViewController(itemToEdit: item)
        viewController.delegate = self
        viewController.navigationItem.title = item.body.isEmpty ? "Add Item" : "Edit Item"

        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Private Selectors

    @objc private func didLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }

        let point = sender.location(in: sender.view)

        if let indexPath = tableView.indexPathForRow(at: point) {
            selectedIndexPath = indexPath

            let item: Item

            if items.isEmpty {
                item = Item()
            } else {
                item = items[indexPath.row]
            }

            presentEditViewController(itemToEdit: item)
        }
    }

    @objc private func didTapAddBarButtonItem(sender: UIBarButtonItem) {
        presentEditViewController()
    }

    @objc private func didTapEditBarButtonItem(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    // MARK: - EditViewControllerDelegate

    func didCancelEditing(_ item: Item, in viewController: EditViewController) {
        selectedIndexPath = nil
        dismiss(animated: true)
    }

    func didFinishEditing(_ item: Item, in viewController: EditViewController) {
        dismiss(animated: true) {
            if let selectedIndexPath = self.selectedIndexPath {

                if self.items.isEmpty {
                    self.items.append(item)
                } else {
                    self.items[selectedIndexPath.row] = item
                }

                self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                self.selectedIndexPath = nil

            } else {
                self.items.append(item)

                let indexPath = IndexPath(row: self.items.count - 1, section: 0)

                if self.items.count == 1 {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
