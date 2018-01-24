
//
//  ShortcutItem.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 12/2/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public enum ShortcutItem {
    case newItem(completion: ((Bool) -> Void)?)

    static var all: [ShortcutItem] {
        return [
            .newItem(completion: nil)
        ]
    }

    public init?(item: UIApplicationShortcutItem, completion: ((Bool) -> Void)? = nil) {
        switch item.type {
        case Globals.ShortcutItemTypes.newItem:
            self = .newItem(completion: completion)
        default:
            return nil
        }
    }
}
