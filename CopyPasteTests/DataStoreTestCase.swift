//
//  DataStoreTestCase.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 4/8/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste
import XCTest

class DataStoreTests: BaseTestCase {
    
    private var subject: DataStore!
    
    override func setUp() {
        super.setUp()
        subject = DataStore(name: "subject")
    }
    
    func testName() {
        let name = "subject"
        XCTAssertEqual(subject.name, name)
    }
    
    func testBaseURL() {
        XCTAssertEqual(subject.baseURL, Globals.dataDirectoryURL)
    }
    
    func testLocation() {
        XCTAssertEqual(subject.location, Globals.dataDirectoryURL.appendingPathComponent(subject.name))
    }
    
    func testDecode() {
        XCTAssertNil(subject.decode(Item.self))
        
        let item = Item(body: "body", copyCount: 0, title: "title")
        subject.encode(item)
        XCTAssertEqual(subject.decode(Item.self)!.body, item.body)
    }
    
    func testRemoveData() {
        XCTAssertNil(subject.decode(Item.self))
        
        subject.encode(Item(body: "body", copyCount: 0, title: "title"))
        
        XCTAssertNotNil(subject.decode(Item.self))
        
        try! subject.removeData(for: Item.self)
        
        XCTAssertNil(subject.decode(Item.self))
    }
}
