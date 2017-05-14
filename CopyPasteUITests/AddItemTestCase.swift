//
//  AddItemTestCase.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/13/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import XCTest

final class AddItemTestCase: TestCase {
    
    private var addItemCell: XCUIElement { return app.tables.cells["Add Item"] }
    private var item0: XCUIElement { return app.tables.cells["Item 0"] }

    // MARK: - Helper Functions

    private func assertAppIsDisplayingAddItemScreen() {
        assertApp(isDisplaying: navigationBars["Add Item"])
    }

    private func tapCancel() {
        navigationBars["Add Item"].buttons["Cancel"].tap()
    }

    private func tapSave() {
        navigationBars["Add Item"].buttons["Save"].tap()
    }

    private func typeText() {
        app.textViews["Body"].typeText("This is just a test.")
    }

    private func tearDown_AddItem_Save_Test() {
        typeText()
        tapSave()
        assertAppIsDisplayingAllItems()
        assertApp(isDisplaying: item0)
        app.terminate()
        app.launch()
        assertApp(isDisplaying: item0)
    }

    private func tearDown_AddItem_Canceled_Test() {
        tapCancel()

        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        XCTAssertFalse(item0.exists)

        app.terminate()
        app.launch()

        assertAppIsDisplayingAllItems()
        assertAppIsDisplayingAddItemCell()
        XCTAssertFalse(item0.exists)
    }

    // MARK: - Add Item Bar Button Tests

    private func setup_AddItemBarButton_Test() {
        assertAppIsDisplayingAllItems()
        tapAddItemBarButtonItem()
        assertAppIsDisplayingAddItemScreen()
    }

    func test_AddItemBarButton_Canceled() {
        setup_AddItemBarButton_Test()
        tearDown_AddItem_Canceled_Test()
    }

    func test_AddItemBarButton_Canceled_Item() {
        setup_AddItemBarButton_Test()
        typeText()
        tearDown_AddItem_Canceled_Test()
    }

    func test_AddItemBarButton_Saved_Item() {
        setup_AddItemBarButton_Test()
        tearDown_AddItem_Save_Test()
    }

    private func tapAddItemBarButtonItem() {
        navigationBars["All Items"].buttons["Add Item"].tap()
    }

    // MARK: - Add Item Cell Tests

    private func setup_AddItemCell_Test() {
        assertAppIsDisplayingAllItems()
        tapAddItemCell()
        assertAppIsDisplayingAddItemScreen()
    }

    func test_AddItemCell_Canceled() {
        setup_AddItemCell_Test()
        tearDown_AddItem_Canceled_Test()
    }

    func test_AddItemCell_Canceled_Item() {
        setup_AddItemCell_Test()
        typeText()
        tearDown_AddItem_Canceled_Test()
    }

    func test_AddItemCell_Saved_Item() {
        setup_AddItemCell_Test()
        tearDown_AddItem_Save_Test()
    }

    private func tapAddItemCell() {
        addItemCell.tap()
    }

    private func assertAppIsDisplayingAddItemCell() {
        assertApp(isDisplaying: addItemCell)
    }
}
