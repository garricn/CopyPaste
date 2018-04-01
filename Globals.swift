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
        static let defaults = "defaults"
        static let items = "items"
        static let shortcutItemKey = "UIApplicationLaunchOptionsShortcutItemKey"
    }
    
    public enum UITestingResetAction {
        static let data = "uiTesting.reset.data"
        static let defaults = "uiTesting.reset.defaults"
        static let dataAndDefaults = "uiTesting.reset.dataAndDefaults"
        static let cancel = "uiTesting.reset.cancel"
    }
}
