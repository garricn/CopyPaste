//
//  Item.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/6/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

class Item: NSObject, NSCoding {
    let body: String
    
    init(body: String) {
        self.body = body
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let body = aDecoder.decodeObject(forKey: "body") as? String {
            self.init(body: body)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(body, forKey: "body")
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
}
