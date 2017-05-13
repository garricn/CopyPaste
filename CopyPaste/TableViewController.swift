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
                print("saved")
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

        navigationItem.title = "All Items"

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let addAction = #selector(didTapAddBarButtonItem)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        navigationItem.leftBarButtonItem = addButton

        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.isEnabled = !items.isEmpty
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

        let bodyText: String
        let countText: String

        if items.isEmpty {
            bodyText = "Add Item"
            countText = ""
        } else {
            let item = items[indexPath.row]
            bodyText = item.body
            countText = "Copy Count: \(item.copyCount)"
        }

        cell.bodyText = bodyText
        cell.countText = countText
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                tableView.reloadRows(at: [indexPath], with: .none)
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

        UIPasteboard.general.string = item.body
        presentAlert()

        // Increment copy count

        let newItem = Item(body: item.body, copyCount: item.copyCount + 1)
        items.remove(at: index)
        items.insert(newItem, at: index)
    }

    private func presentAlert() {
        let editAction = UIAlertAction(title: "Edit", style: .destructive, handler: editHandler)
        let alert = UIAlertController(title: nil, message: "Copied to Pasteboard!", preferredStyle: .alert)
        alert.addAction(editAction)

        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let _ = self.presentedViewController as? UIAlertController {
                    self.dismiss(animated: true) {
                        if let indexPath = self.selectedIndexPath {
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            self.tableView.deselectRow(at: indexPath, animated: true)
                            self.selectedIndexPath = nil
                        }
                    }
                }
            }
        }
    }

    private func okHandler(sender: UIAlertAction) {
        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            self.selectedIndexPath = nil
        }
    }

    private func editHandler(sender: UIAlertAction) {
        if let indexPath = selectedIndexPath {
            let item = items[indexPath.row]
            presentEditViewController(itemToEdit: item)
        } else {
            fatalError("Expects IndexPath!")
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

    @objc private func didTapAddBarButtonItem(sender: UIBarButtonItem) {
        presentEditViewController()
    }

    @objc private func didTapEditBarButtonItem(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    // MARK: - EditViewControllerDelegate

    func didCancelEditing(_ item: Item, in viewController: EditViewController) {

        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            selectedIndexPath = nil
        }

        dismiss(animated: true)
    }

    func didFinishEditing(_ item: Item, in viewController: EditViewController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }

        if tableView.isEditing  {
            tableView.setEditing(false, animated: false)
        }

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
