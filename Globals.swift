//
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public enum Globals {
    public static let bundleIdentifier = "com.swiftcoders.copypaste"
    public static let  dataDirectoryURL = Globals.directoryURL.appendingPathComponent("copypaste")
    private static let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    public enum ShortcutItemTypes {
        public static let newItem = [Globals.bundleIdentifier, "newItem"].joined(separator: ".")
    }

    public enum EnvironmentVariables {
        static let codables = "codables"
        static let defaults = "defaults"
        static let items = "items"
        static let shortcutItemKey = "UIApplicationLaunchOptionsShortcutItemKey"
    }
}
