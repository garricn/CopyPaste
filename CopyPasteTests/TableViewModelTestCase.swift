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
        let cell = subject.cell(forRowAt: indexPath, in: UITableView())
        XCTAssertEqual(cell.textLabel?.text, "Add Item")
        XCTAssertEqual(cell.detailTextLabel?.text, "")
    }
    
    func testCellGivenItemWithNoTitle() {
        let item = Item.init(body: "Body")
        subject = TableViewModel(items: [item])
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = subject.cell(forRowAt: indexPath, in: UITableView())
        XCTAssertEqual(cell.textLabel?.text, "Body")
        XCTAssertEqual(cell.detailTextLabel?.text, "")
    }
    
    func testCellItemWithTitle() {
        // given
        let item = Item.init(body: "Body", copyCount: 0, title: "Title")
        subject = TableViewModel(items: [item])
        
        // when
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = subject.cell(forRowAt: indexPath, in: UITableView())
        
        // then
        XCTAssertEqual(cell.textLabel?.text, "Title")
        XCTAssertEqual(cell.detailTextLabel?.text, "Body")
    }

    func test_Configured_Cell_Given_Two_Items() {
        let item0 = Item(body: "Item 0")
        let item1 = Item(body: "Item 1")
        subject = TableViewModel(items: [item0, item1])

        let indexPath0 = IndexPath(row: 0, section: 0)
        let cell0 = subject.cell(forRowAt: indexPath0, in: UITableView())
        XCTAssertTrue(cell0.textLabel?.text == "Item 0")

        let indexPath1 = IndexPath(row: 1, section: 0)
        let cell1 = subject.cell(forRowAt: indexPath1, in: UITableView())
        XCTAssertTrue(cell1.textLabel?.text == "Item 1")
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
