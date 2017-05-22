//
//  CopyPasteTests.swift
//  CopyPasteTests
//
//  Created by Garric G. Nahapetian on 5/21/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest
@testable import CopyPaste

final class TableViewModelTestCase: XCTestCase, TableViewModelingDelegate {

    private var subject: TableViewModel!

    private let tableView = TableView()
    private var isEditButtonEnabled: Bool = false
    private var didTapAddItem: Bool = false
    private var didCopyItem: (bool: Bool, item: Item?) =  (false, nil)
    private var didLongPressItem: (bool: Bool, item: Item?) = (false, nil)
    private var didReloadRowsAtIndexPaths: (bool: Bool, indexPaths: [IndexPath]) = (false, [])

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    private func setupSubject() {
        subject.delegate = self

        subject.isEditButtonEnabled = { [weak self] isEnabled in
            self?.isEditButtonEnabled = isEnabled
        }

        subject.reloadRowsAtIndexPaths = { [weak self] indexPaths in
            self?.didReloadRowsAtIndexPaths = (true, indexPaths)
        }

        XCTAssertTrue(subject.numberOfSections == 1)
    }

    func test_Given_Zero_Items() {
        let indexPath = IndexPath(row: 0, section: 0)

        subject = TableViewModel(items: [])
        setupSubject()

        subject.viewDidLoad()
        XCTAssertFalse(isEditButtonEnabled)

        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath) == .none)
        XCTAssertFalse(subject.canEditRow(at: indexPath))

        subject.didSelectRow(at: indexPath, in: tableView)
        XCTAssertTrue(didTapAddItem)
        XCTAssertFalse(didCopyItem.bool)

        subject.didLongPressRow(at: indexPath, in: tableView)
        XCTAssertTrue(didLongPressItem.bool)
        XCTAssertTrue(didLongPressItem.item!.body.isEmpty)
        XCTAssertTrue(didLongPressItem.item!.copyCount == 0)

        subject.configureWithEdited(item: Item())
        XCTAssertTrue(didReloadRowsAtIndexPaths.bool)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.row == 0)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.section == 0)

        subject.commit(edit: .delete, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")

        subject.commit(edit: .insert, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")

        subject.commit(edit: .none, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")
    }

    func test_Given_One_Item() {
        let indexPath = IndexPath(row: 0, section: 0)
        let item = Item(body: "Item 0", copyCount: 0)

        subject = TableViewModel(items: [item])
        setupSubject()

        subject.viewDidLoad()
        XCTAssertTrue(isEditButtonEnabled)
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Item 0")
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath) == .delete)
        XCTAssertTrue(subject.canEditRow(at: indexPath))

        subject.didSelectRow(at: indexPath, in: tableView)
        XCTAssertFalse(didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertTrue(didCopyItem.item!.body == "Item 0")
        XCTAssertTrue(didCopyItem.item!.copyCount == 1)

        subject.didLongPressRow(at: indexPath, in: tableView)
        XCTAssertTrue(didLongPressItem.bool)
        XCTAssertTrue(didLongPressItem.item!.body == "Item 0")
        XCTAssertTrue(didLongPressItem.item!.copyCount == 1)

        subject.configureWithEdited(item: item)
        XCTAssertTrue(didReloadRowsAtIndexPaths.bool)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.row == 0)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.section == 0)

        subject.commit(edit: .delete, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")

        subject.commit(edit: .insert, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")

        subject.commit(edit: .none, forRowAt: indexPath, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath, in: tableView).bodyText == "Add Item")
    }

    func test_Given_Two_Items() {
        let indexPath0 = IndexPath(row: 0, section: 0)
        let indexPath1 = IndexPath(row: 1, section: 0)
        let item0 = Item(body: "Item 0", copyCount: 0)
        let item1 = Item(body: "Item 1", copyCount: 0)

        subject = TableViewModel(items: [item0, item1])
        setupSubject()

        subject.viewDidLoad()
        XCTAssertTrue(isEditButtonEnabled)
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 2)

        // Item 0

        XCTAssertTrue(subject.cellForRow(at: indexPath0, in: tableView).bodyText == "Item 0")
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath0) == .delete)
        XCTAssertTrue(subject.canEditRow(at: indexPath0))

        subject.didSelectRow(at: indexPath0, in: tableView)
        XCTAssertFalse(didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertTrue(didCopyItem.item!.body == "Item 0")
        XCTAssertTrue(didCopyItem.item!.copyCount == 1)

        subject.didLongPressRow(at: indexPath0, in: tableView)
        XCTAssertTrue(didLongPressItem.bool)
        XCTAssertTrue(didLongPressItem.item!.body == "Item 0")
        XCTAssertTrue(didLongPressItem.item!.copyCount == 1)

        subject.configureWithEdited(item: item0)
        XCTAssertTrue(didReloadRowsAtIndexPaths.bool)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.row == 0)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.section == 0)

        // Item 1

        XCTAssertTrue(subject.cellForRow(at: indexPath1, in: tableView).bodyText == "Item 1")
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath1) == .delete)
        XCTAssertTrue(subject.canEditRow(at: indexPath1))

        subject.didSelectRow(at: indexPath1, in: tableView)
        XCTAssertFalse(didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertTrue(didCopyItem.item!.body == "Item 1")
        XCTAssertTrue(didCopyItem.item!.copyCount == 1)

        subject.didLongPressRow(at: indexPath1, in: tableView)
        XCTAssertTrue(didLongPressItem.bool)
        XCTAssertTrue(didLongPressItem.item!.body == "Item 1")
        XCTAssertTrue(didLongPressItem.item!.copyCount == 1)

        subject.configureWithEdited(item: item1)
        XCTAssertTrue(didReloadRowsAtIndexPaths.bool)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.row == 1)
        XCTAssertTrue(didReloadRowsAtIndexPaths.indexPaths.first!.section == 0)

        // Edit

        subject.commit(edit: .delete, forRowAt: indexPath0, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath0, in: tableView).bodyText == "Item 1")

        subject.commit(edit: .insert, forRowAt: indexPath0, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath0, in: tableView).bodyText == "Item 1")

        subject.commit(edit: .none, forRowAt: indexPath0, in: UITableViewController())
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(subject.cellForRow(at: indexPath0, in: tableView).bodyText == "Item 1")
    }

    // MARK: - TableViewModelingDelegate

    func didLongPress(on item: Item, in viewModel: TableViewModeling) {
        didLongPressItem = (true, item)
    }

    func didTapAddItem(in viewModel: TableViewModeling) {
        didTapAddItem = true
    }

    func didCopy(item: Item, in viewModel: TableViewModeling) {
        didCopyItem = (true, item)
    }
}
