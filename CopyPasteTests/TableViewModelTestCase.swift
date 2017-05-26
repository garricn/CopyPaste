//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest
@testable import CopyPaste

final class TableViewModelTestCase: XCTestCase, TableViewModelingDelegate {

    // MARK: - Test Subject

    private var subject: TableViewModel = TableViewModel(items: []) {
        didSet {
            setupSubject()
        }
    }

    // MARK: - Private Variables

    private var isEditButtonEnabled: Bool = false
    private var _didTapAddItem: Bool = false
    private var didCopyItem: (bool: Bool, item: Item?) =  (false, nil)
    private var didLongPressItem: (bool: Bool, item: Item?) = (false, nil)
    private var didReloadRows: (bool: Bool, indexPaths: [IndexPath]) = (false, [])
    private var didInsertRows: (bool: Bool, indexPaths: [IndexPath]) = (false, [])
    private var didDeleteRows: (bool: Bool, indexPaths: [IndexPath]) = (false, [])
    private var didDeselectRow: (bool: Bool, indexPath: IndexPath?) = (false, nil)
    private var didSetEditing: (bool: Bool, value: Bool) = (false, true)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    private func setupSubject() {
        subject.delegate = self

        subject.isEditButtonEnabled = { [weak self] isEnabled in
            self?.isEditButtonEnabled = isEnabled
        }

        subject.reloadRows = { [weak self] indexPaths, _ in
            self?.didReloadRows = (true, indexPaths)
        }

        subject.insertRows = { [weak self] indexPaths, _ in
            self?.didInsertRows = (true, indexPaths)
        }

        subject.deleteRows = { [weak self] indexPaths, _ in
            self?.didDeleteRows = (true, indexPaths)
        }

        subject.deselectRow = { [weak self] indexPath, _ in
            self?.didDeselectRow = (true, indexPath)

        }

        subject.setEditing = { [weak self] value, _ in
            self?.didSetEditing = (true, value)
        }

        XCTAssertTrue(subject.numberOfSections == 1)
        XCTAssertTrue(subject.cellIdentifier == TableViewCell.identifier)
    }

    // MARK: viewDidLoad()

    func test_View_Did_Load_Given_Zero_Items() {
        subject = TableViewModel()
        subject.viewDidLoad()
        XCTAssertFalse(isEditButtonEnabled)
    }

    func test_View_Did_Load_Given_Non_Zero_Items() {
        subject = TableViewModel()
        subject.viewDidLoad()
        XCTAssertTrue(!isEditButtonEnabled)
    }

    // MARK: numberOfRows(inSection section: Int) -> Int

    func test_Number_Of_Rows_Given_Zero_Items() {
        subject = TableViewModel(items: [])
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
    }

    func test_Number_Of_Rows_Given_One_Item() {
        let item = Item()
        subject = TableViewModel(items: [item])
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
    }

    func test_Number_Of_Rows_Given_Two_Items() {
        let item0 = Item()
        let item1 = Item()
        subject = TableViewModel(items: [item0, item1])
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 2)
    }

    // MARK: configured(cell:forRowAt:) -> TableViewCell

    func test_Configured_Cell_Given_Zero_Items() {
        subject = TableViewModel(items: [])

        let indexPath = IndexPath(row: 0, section: 0)
        let cell = subject.configured(cell: TableViewCell(), forRowAt: indexPath)
        XCTAssertTrue(cell.bodyText == "Add Item")
    }

    func test_Configured_Cell_Given_One_Item() {
        let item = Item(body: "Item 0")
        subject = TableViewModel(items: [item])

        let indexPath = IndexPath(row: 0, section: 0)
        let cell = subject.configured(cell: TableViewCell(), forRowAt: indexPath)
        XCTAssertTrue(cell.bodyText == "Item 0")
    }

    func test_Configured_Cell_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let indexPath0 = IndexPath(row: 0, section: 0)
        let cell0 = subject.configured(cell: TableViewCell(), forRowAt: indexPath0)
        XCTAssertTrue(cell0.bodyText == "Item 0")

        let indexPath1 = IndexPath(row: 1, section: 0)
        let cell1 = subject.configured(cell: TableViewCell(), forRowAt: indexPath1)
        XCTAssertTrue(cell1.bodyText == "Item 1")
    }

    // MARK: didSelectRow(at indexPath: IndexPath)

    func test_Did_Select_Given_Zero_Items() {
        let pasteboard = MockPasteboard()
        subject = TableViewModel.init(items: [], pasteboard: pasteboard)

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didSelectRow(at: indexPath)

        XCTAssertTrue(didDeselectRow.bool)
        XCTAssertTrue(didDeselectRow.indexPath == indexPath)
        XCTAssertTrue(_didTapAddItem)
        XCTAssertFalse(didCopyItem.bool)
        XCTAssertNil(pasteboard.string)
    }

    func test_Did_Select_Given_One_Item() {
        let item = Item(body: "Item 0")
        let pasteboard = MockPasteboard()
        subject = TableViewModel.init(items: [item], pasteboard: pasteboard)

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didSelectRow(at: indexPath)

        XCTAssertTrue(didDeselectRow.bool)
        XCTAssertTrue(didDeselectRow.indexPath == indexPath)
        XCTAssertFalse(_didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertNotNil(didCopyItem.item)

        if let copiedItem = didCopyItem.item {
            XCTAssertTrue(copiedItem.body == item.body)
            XCTAssertTrue(copiedItem.copyCount == item.copyCount + 1)
        }

        XCTAssertNotNil(pasteboard.string)

        if let copiedString = pasteboard.string {
            XCTAssertTrue(copiedString == item.body)
        }
    }

    func test_Did_Select_Item_0_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        let pasteboard = MockPasteboard()
        subject = TableViewModel.init(items: [item0, item1], pasteboard: pasteboard)

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didSelectRow(at: indexPath)

        XCTAssertTrue(didDeselectRow.bool)
        XCTAssertTrue(didDeselectRow.indexPath == indexPath)
        XCTAssertFalse(_didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertNotNil(didCopyItem.item)

        if let copiedItem = didCopyItem.item {
            XCTAssertTrue(copiedItem.body == item0.body)
            XCTAssertTrue(copiedItem.copyCount == item0.copyCount + 1)
        }

        XCTAssertNotNil(pasteboard.string)

        if let copiedString = pasteboard.string {
            XCTAssertTrue(copiedString == item0.body)
        }
    }

    func test_Did_Select_Item_1_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        let pasteboard = MockPasteboard()
        subject = TableViewModel.init(items: [item0, item1], pasteboard: pasteboard)

        let indexPath = IndexPath(row: 1, section: 0)
        subject.didSelectRow(at: indexPath)

        XCTAssertTrue(didDeselectRow.bool)
        XCTAssertTrue(didDeselectRow.indexPath == indexPath)
        XCTAssertFalse(_didTapAddItem)
        XCTAssertTrue(didCopyItem.bool)
        XCTAssertNotNil(didCopyItem.item)

        if let copiedItem = didCopyItem.item {
            XCTAssertTrue(copiedItem.body == item1.body)
            XCTAssertTrue(copiedItem.copyCount == item1.copyCount + 1)
        }

        XCTAssertNotNil(pasteboard.string)

        if let copiedString = pasteboard.string {
            XCTAssertTrue(copiedString == item1.body)
        }
    }

    // MARK: didLongPressRow(at indexPath: IndexPath)

    func test_Did_Long_Press_Given_Zero_Items() {
        subject = TableViewModel()

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didLongPressRow(at: indexPath)

        XCTAssertTrue(_didTapAddItem)
        XCTAssertFalse(didLongPressItem.bool)
    }

    func test_Did_Long_Press_Given_One_Item() {
        let item = Item()
        subject = TableViewModel(items: [item])

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didLongPressRow(at: indexPath)

        XCTAssertTrue(didLongPressItem.bool)
        XCTAssertFalse(_didTapAddItem)
    }

    func test_Did_Long_Press_Item_0_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let indexPath = IndexPath(row: 0, section: 0)
        subject.didLongPressRow(at: indexPath)

        XCTAssertTrue(didLongPressItem.bool)

        if let longPressedItem = didLongPressItem.item {
            XCTAssertTrue(longPressedItem.body == "Item 0")
        }

        XCTAssertFalse(_didTapAddItem)
    }

    func test_Did_Long_Press_Item_1_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let indexPath = IndexPath(row: 1, section: 0)
        subject.didLongPressRow(at: indexPath)

        XCTAssertTrue(didLongPressItem.bool)

        if let longPressedItem = didLongPressItem.item {
            XCTAssertTrue(longPressedItem.body == "Item 1")
        }

        XCTAssertFalse(_didTapAddItem)
    }

    // MARK: commit(edit:forRowAt:)

    private var cell: TableViewCell { return TableViewCell() }

    func test_Commit_Delete_Given_Zero_Items() {
        subject = TableViewModel(items: [])

        let indexPath = IndexPath(row: 0, section: 0)

        subject.commit(edit: .delete, forRowAt: indexPath)
        XCTAssertFalse(didDeleteRows.bool)
        XCTAssertFalse(didReloadRows.bool)
        XCTAssertFalse(didInsertRows.bool)
        XCTAssertFalse(didSetEditing.bool)
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)

        let _cell = subject.configured(cell: cell, forRowAt: indexPath)
        XCTAssertTrue(_cell.bodyText == "Add Item")
    }

    func test_Commit_Delete_Given_One_Item() {
        let item = Item(body: "Item 0")
        subject = TableViewModel(items: [item])

        let indexPath = IndexPath(row: 0, section: 0)
        subject.commit(edit: .delete, forRowAt: indexPath)

        XCTAssertFalse(didDeleteRows.bool)
        XCTAssertTrue(didReloadRows.bool)
        XCTAssertFalse(didInsertRows.bool)
        XCTAssertTrue(didSetEditing.bool)
        XCTAssertFalse(didSetEditing.value)
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)

        let _cell = subject.configured(cell: cell, forRowAt: indexPath)
        XCTAssertTrue(_cell.bodyText == "Add Item")
    }

    func test_Commit_Delete_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let indexPath = IndexPath(row: 0, section: 0)
        subject.commit(edit: .delete, forRowAt: indexPath)

        XCTAssertTrue(didDeleteRows.bool)
        XCTAssertFalse(didReloadRows.bool)
        XCTAssertFalse(didInsertRows.bool)
        XCTAssertFalse(didSetEditing.bool)
        XCTAssertTrue(subject.numberOfRows(inSection: 0) == 1)
    }

    // MARK: editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle

    func test_Editing_Style_Given_Zero_Items() {
        subject = TableViewModel(items: [])

        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath) == .none)
    }

    func test_Editing_Style_Given_One_Item() {
        let item = Item()
        subject = TableViewModel(items: [item])

        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath) == .delete)
    }

    func test_Editing_Style_Given_Two_Items() {
        let item0 = Item()
        let item1 = Item()
        subject = TableViewModel(items: [item0, item1])

        let indexPath0 = IndexPath(row: 0, section: 0)
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath0) == .delete)

        let indexPath1 = IndexPath(row: 1, section: 0)
        XCTAssertTrue(subject.editingStyleForRow(at: indexPath1) == .delete)
    }

    // MARK: canEditRow(at indexPath: IndexPath) -> Bool

    func test_Can_Edit_Given_Zero_Items() {
        subject = TableViewModel(items: [])

        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertFalse(subject.canEditRow(at: indexPath))
    }

    func test_Can_Edit_Given_One_Item() {
        let item = Item()
        subject = TableViewModel(items: [item])

        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertTrue(subject.canEditRow(at: indexPath))
    }

    func test_Can_Edit_Given_Two_Items() {
        let item0 = Item()
        let item1 = Item()
        subject = TableViewModel(items: [item0, item1])

        let indexPath0 = IndexPath(row: 0, section: 0)
        let indexPath1 = IndexPath(row: 1, section: 0)
        XCTAssertTrue(subject.canEditRow(at: indexPath0))
        XCTAssertTrue(subject.canEditRow(at: indexPath1))
    }

    // MARK: configureWithEdited(item: Item)

    func test_Configure_With_Edited_Given_Zero_Items() {
        subject = TableViewModel()

        let item = Item(body: "Item")
        let indexPath = IndexPath(row: 0, section: 0)
        subject.configureWithEdited(item: item, at: indexPath)
        XCTAssertTrue(didReloadRows.bool)
        XCTAssertTrue(didReloadRows.indexPaths[0].row == 0)
        XCTAssertTrue(didReloadRows.indexPaths[0].section == 0)
        XCTAssertFalse(didInsertRows.bool)
    }

    func test_Configure_With_Edited_Given_One_Item() {
        let item0 = Item(body: "Item 0")
        subject = TableViewModel(items: [item0])

        let editedItem = Item(body: "Edited Item")
        let indexPath = IndexPath(row: 0, section: 0)
        subject.configureWithEdited(item: editedItem, at: indexPath)
        XCTAssertTrue(didReloadRows.bool)
        XCTAssertTrue(didReloadRows.indexPaths[0].row == 0)
        XCTAssertTrue(didReloadRows.indexPaths[0].section == 0)
        XCTAssertFalse(didInsertRows.bool)
    }

    func test_Configure_With_Edited_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let editedItem = Item(body: "Edited Item")
        let indexPath = IndexPath(row: 1, section: 0)
        subject.configureWithEdited(item: editedItem, at: indexPath)
        XCTAssertTrue(didReloadRows.bool)
        XCTAssertTrue(didReloadRows.indexPaths[0].row == 1)
        XCTAssertTrue(didReloadRows.indexPaths[0].section == 0)
        XCTAssertFalse(didInsertRows.bool)
    }

    // MARK: - TableViewModelingDelegate

    func didLongPress(on item: Item, at indexPath: IndexPath) {
        didLongPressItem = (true, item)
    }

    func didTapAddItem() {
        _didTapAddItem = true
    }

    func didCopy(item: Item) {
        didCopyItem = (true, item)
    }
}

private final class MockPasteboard: PasteboardProtocol {
    var string: String?
}
