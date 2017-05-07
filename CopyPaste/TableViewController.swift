//
//  TableViewController.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 4/5/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, EditViewControllerDelegate {

    private var items: [Item] = [] {
        didSet {
            let objects = items.map(toItemObject)
            if ItemObject.archive(objects) {
                print("saved")
            } else {
                print("error")
            }
        }
    }

    private var selectedIndexPath: IndexPath?

    // MARK: - Life Cycle

    init(items: [Item]) {
        self.items = items
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "All Items"

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        let addAction = #selector(didTapAddBarButtonItem)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction)
        navigationItem.leftBarButtonItem = addButton

        let editAction = #selector(didTapEditBarButtonItem)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: editAction)
        navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.isEmpty ? 1 : items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let cell = dequeuedCell ?? UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.numberOfLines = 0

        let text: String

        if items.isEmpty {
            text = "Add Something"
            cell.accessoryView = UIButton(type: .contactAdd)
        } else {
            text = items[indexPath.section].body
            cell.accessoryType = .none
            cell.accessoryView = nil
        }

        cell.textLabel?.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let title: String?

        if items.isEmpty {
            title = nil
        } else {
            let item = items[section]
            title = "Copy count: \(item.copyCount)"
        }

        return title
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

        guard !items.isEmpty else {
            return
        }

        switch editingStyle {
        case .delete:
            items.remove(at: indexPath.section)
            if items.isEmpty {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert: break
        case .none: break
        }
    }

    // MARK: - Private Functions

    private func copyItem(at indexPath: IndexPath) {
        let index = indexPath.section
        let item = items[indexPath.section]

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
                            self.tableView.deselectRow(at: indexPath, animated: true)
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
        if let indexPath = tableView.indexPathForSelectedRow {
            let item = items[indexPath.section]
            presentEditViewController(itemToEdit: item)
        } else {
            fatalError("Expects IndexPath!")
        }
    }

    private func presentEditViewController(itemToEdit item: Item = Item(body: "")) {
        let viewController = EditViewController(itemToEdit: item)
        viewController.delegate = self

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
        dismiss(animated: true) {
            if let indexPath = self.selectedIndexPath {
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.selectedIndexPath = nil
            }
        }
    }

    func didFinishEditing(_ item: Item, in viewController: EditViewController) {
        dismiss(animated: true) {

            let indexPath: IndexPath

            if let selectedIndexPath = self.selectedIndexPath {
                indexPath = selectedIndexPath

                if self.items.isEmpty {
                    self.items.append(item)
                } else {
                    self.items[selectedIndexPath.section] = item
                }

                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.selectedIndexPath = nil
            } else {
                indexPath = IndexPath(row: 0, section: self.items.count)
                self.items.insert(item, at: indexPath.section)
                self.tableView.reloadData()
            }
        }
    }
}
