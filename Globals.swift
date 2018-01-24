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

    public enum ShortcutItemTypes {
        public static let newItem = [Globals.bundleIdentifier, "newItem"].joined(separator: ".")
    }

    public enum EnvironmentVariables {
        static let resetData = "resetData"
        static let showWelcome = "showWelcome"
        static let resetDefaults = "resetDefaults"
        static let shortcutItemKey = "UIApplicationLaunchOptionsShortcutItemKey"
    }
}
