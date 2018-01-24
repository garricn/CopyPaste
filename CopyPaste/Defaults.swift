//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

public final class Defaults {

    public var shouldShowWelcomeScreen: Bool {
        get {
            return standard.bool(forKey: .shouldShowWelcomeScreen)
        }
        set {
            standard.set(newValue, forKey: .shouldShowWelcomeScreen)
            standard.synchronize()
        }
    }

    public var shouldResetUserDefaults: Bool {
        get {
            return standard.bool(forKey: .shouldResetUserDefaults)
        }
        set {
            standard.set(newValue, forKey: .shouldResetUserDefaults)
            standard.synchronize()
        }
    }

    private let standard: UserDefaults = .standard

    public init(resetUserDefaults: Bool = CommandLine.arguments.contains(Globals.LaunchArguments.resetUserDefaults),
                showWelcomeScreen: Bool = false) {

        guard resetUserDefaults || standard.bool(forKey: .shouldResetUserDefaults) else {
            self.shouldShowWelcomeScreen = showWelcomeScreen
            return
        }

        self.shouldResetUserDefaults = false
        self.shouldShowWelcomeScreen = true
    }
}

private extension String {
    static let shouldResetUserDefaults = Globals.LaunchArguments.resetUserDefaults
    static let shouldShowWelcomeScreen = "showWelcomeScreen"
}
