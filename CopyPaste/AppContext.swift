//
//  AppContext.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class AppContext {

    enum State {
        case welcome
        case session
    }

    private let application: UIApplication
    private let defaults = Defaults()
    private let launch: Launch

    var state: State { return determineState() }
    var isForegroundLaunch: Bool { return launch.kind == .foreground }
    
    init(application: UIApplication, launchOptions: LaunchOptions?) {
        self.application = application
        self.launch = Launch(launchOptions: launchOptions)
    }

    func didViewWelcomeScreen() {
        defaults.shouldShowWelcomeScreen = false
    }
    private func determineState() -> State {
        switch launch.reason {
        case .normal:
            return determineStateForNormalLaunch()
        }
    }

    private func determineStateForNormalLaunch() -> State {
        if defaults.shouldShowWelcomeScreen {
            return .welcome
        } else {
            return .session
        }
    }
}

private extension AppContext {
    struct Launch {
        let reason: Reason
        var kind: Kind { return reason.kind }
        init(launchOptions: LaunchOptions?) {
            self.reason = Reason(launchOptions: launchOptions)
        }
    }
}

private extension AppContext.Launch {
    enum Reason {
        case normal
        init(launchOptions: LaunchOptions?) {
            if launchOptions == nil {
                self = .normal
            } else {
                fatalError()
            }
        }
        var kind: Kind {
            switch self {
            case .normal:
                return .foreground
            }
        }
    }

    enum Kind {
        case foreground, background
    }
}
