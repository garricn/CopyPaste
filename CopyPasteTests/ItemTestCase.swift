//
//  ItemTestCase.swift
//  CopyPasteTests
//
//  Created by Garric Nahapetian on 4/8/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

@testable import CopyPaste
import XCTest

class ItemTestCase: BaseTestCase {
    
    func testUrlsCount1() {
        let item = Item(body: "apple.com")
        XCTAssertEqual(item.urls.count, 1)
    }
    
    func testUrlsCount2() {
        let item = Item(body: "apple.com google.com")
        XCTAssertEqual(item.urls.count, 2)
    }
    
    func testUrl1() {
        let url = URL(string: "http://apple.com")!
        let item = Item(body: "apple.com")
        XCTAssertEqual(item.urls.first!, url)
    }
    
    func testUrl2() {
        let apple = URL(string: "http://apple.com")!
        let google = URL(string: "http://google.com")!
        let item = Item(body: "apple.com google.com")
        XCTAssertEqual(item.urls[0], apple)
        XCTAssertEqual(item.urls[1], google)
    }
}
