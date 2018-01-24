//
//  Globals.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/24/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public enum Globals {
    public static let bundleIdentifier = "com.swiftcoders.copypaste"

    public enum LaunchArguments {
        public static let isUITesting = Launch.Argument.isUITesting.rawValue
        public static let resetUserDefaults = Launch.Argument.resetUserDefaults.rawValue
        public static let resetData = Launch.Argument.resetData.rawValue
        public static let newItemShortcutItem = Launch.Argument.newItemShortcutItem.rawValue
    }

    public enum ShortcutItemTypes {
        public static let newItem = Globals.bundleIdentifier.appending(".newItem")
    }
}
