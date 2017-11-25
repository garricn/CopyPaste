//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest
@testable import CopyPaste

final class TableViewModelTestCase: XCTestCase {

    private var subject: TableViewModel = TableViewModel(items: []) {
        didSet {
            performInitialAssertions()
        }
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    private func performInitialAssertions() {
        XCTAssertTrue(subject.numberOfSections == 1)
        XCTAssertTrue(subject.cellIdentifier == TableViewCell.identifier)
    }

    // MARK: - TEST: isEditButtonEnabled: Bool

    func test_Edit_Button_Is_Not_Enabled_Given_Zero_Items() {
        subject = TableViewModel()
        XCTAssertTrue(!subject.isEditButtonEnabled)
    }

    func test_Edit_Button_Is_Enabled_Given_Non_Zero_Items() {
        subject = TableViewModel(items: [Item()])
        XCTAssertTrue(subject.isEditButtonEnabled)
    }

    // MARK: - TEST: numberOfRows(inSection section: Int) -> Int

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

    // MARK: - TEST: configured(cell:forRowAt:) -> TableViewCell

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

    // MARK: - TEST: editingStyleForRow(at indexPath: IndexPath) -> UITableViewCellEditingStyle

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

    // MARK: - TEST: canEditRow(at indexPath: IndexPath) -> Bool

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
}
