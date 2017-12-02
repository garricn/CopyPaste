//
//  ShortcutItem.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 12/2/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

enum ShortcutItem {
    case newItem(completion: ((Bool) -> Void)?)
    init(item: UIApplicationShortcutItem, completion: ((Bool) -> Void)? = nil) {
        switch item.type {
        case "com.swiftcoders.copypaste.newitem":
            self = .newItem(completion: completion)
        default:
            fatalError("Application does not support other type: \(item.type)")
        }
    }
}
