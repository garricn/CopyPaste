//
//  Item.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/6/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

final class ItemObject: NSObject, NSCoding {
    let body: String
    let copyCount: Int

    init(body: String, copyCount: Int) {
        self.body = body
        self.copyCount = copyCount
    }

    convenience init(item: Item) {
        self.init(body: item.body, copyCount: item.copyCount)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let body = aDecoder.decodeObject(forKey: "body") as? String else {
            return nil
        }

        let copyCount = aDecoder.decodeInteger(forKey: "copyCount")

        self.init(body: body, copyCount: copyCount)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(body, forKey: "body")
        aCoder.encode(copyCount, forKey: "copyCount")
    }

    private static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")

    static func unarchived() -> [ItemObject] {
        let file = ItemObject.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [ItemObject] ?? []
    }

    static func asValue(from object: ItemObject) -> Item {
        return Item.init(itemObject: object)
    }

    static func archive(_ objects: [ItemObject]) -> Bool {
        if NSKeyedArchiver.archiveRootObject(objects, toFile: ItemObject.ArchiveURL.path) {
            return true
        } else {
            return false
        }
    }
}

func toItemObject(from item: Item) -> ItemObject {
    return ItemObject(item: item)
}

struct Item {
    let body: String
    let copyCount: Int

    init(body: String = "", copyCount: Int = 0) {
        self.body = body
        self.copyCount = copyCount
    }

    init(itemObject: ItemObject) {
        self.init(body: itemObject.body, copyCount: itemObject.copyCount)
    }
}

func toItem(from object: ItemObject) -> Item {
    return Item(itemObject: object)
}
