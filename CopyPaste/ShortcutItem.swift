
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
}

public extension ShortcutItem {

    public init?(options: Options) {
        guard let item = options[.shortcutItem] as? UIApplicationShortcutItem else {
            return nil
        }
        self.init(item: item)
    }

    public init?(argument: Launch.Argument) {
        switch argument {
        case .newItemShortcutItem:
            self = .newItem(completion: nil)
        default:
            return nil
        }
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
