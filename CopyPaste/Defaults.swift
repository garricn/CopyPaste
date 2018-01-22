//
//  Defaults.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

final class Defaults {

    var shouldShowWelcomeScreen: Bool {
        get {
            return standard.bool(forKey: .shouldShowWelcomeScreen)
        }
        set {
            standard.set(newValue, forKey: .shouldShowWelcomeScreen)
            standard.synchronize()
        }
    }

    var shouldResetUserDefaults: Bool {
        get {
            return standard.bool(forKey: .shouldResetUserDefaults)
        }
        set {
            standard.set(newValue, forKey: .shouldResetUserDefaults)
            standard.synchronize()
        }
    }

    private let standard: UserDefaults = .standard

    init(shouldResetUserDefaults: Bool = CommandLine.arguments.contains("resetDefaults"),
         shouldShowWelcomeScreen: Bool = CommandLine.arguments.contains("shouldShowWelcomeScreen")) {

        guard shouldResetUserDefaults || standard.bool(forKey: .shouldResetUserDefaults) else {
            self.shouldShowWelcomeScreen = shouldShowWelcomeScreen
            return
        }

        self.shouldResetUserDefaults = false
        self.shouldShowWelcomeScreen = true
    }
}

private extension String {
    static let shouldResetUserDefaults = "shouldResetUserDefaults"
    static let shouldShowWelcomeScreen = "shouldShowWelcomeScreen"
}
