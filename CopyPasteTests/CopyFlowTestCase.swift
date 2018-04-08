//
//  CopyFlowTestCase.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 3/31/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste
import XCTest

class CopyFlowTestCase: XCTestCase {
    
    func testCopyItem() {
        // given
        let item = Item(body: "Body", copyCount: 0, title: "Title")
        let items: [Item] = [item]
        let context = AppContext.shared.itemsContext
        context.save(items)
        
        let tableView = UITableView()
        let viewController = TableViewController(tableView: tableView)
        let subject = CopyFlow()
        subject.inputView = viewController
        subject.start(with: UIViewController())
        viewController.viewDidLoad()
        
        // when
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // then
        let copiedItem = subject.items[0]
        XCTAssertEqual(copiedItem.body, item.body)
        XCTAssertEqual(copiedItem.title, item.title)
        XCTAssertEqual(copiedItem.copyCount, item.copyCount + 1)
        XCTAssertEqual(UIPasteboard.general.string, copiedItem.body)
    }
}

class BaseTestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: Globals.dataDirectoryURL)
    }
}
