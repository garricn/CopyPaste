//
//  Launch.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 12/2/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import Foundation

struct Launch {

    enum Kind {
        case foreground
        case background
        init(options: Options?) {
            self = Reason(launchOptions: options).kind
        }
    }

    enum Reason {
        case normal
        var kind: Kind { return .foreground }
        init(launchOptions: Options?) {
            if launchOptions == nil {
                self = .normal
            } else {
                fatalError()
            }
        }
    }

    enum State {
        case welcome
        case session
    }

    let reason: Reason
    let kind: Kind
    let state: State

    init(options: Options?, defaults: Defaults = Defaults()) {
        self.reason = Reason(launchOptions: options)
        self.kind = reason.kind
        self.state = defaults.shouldShowWelcomeScreen ? .welcome : .session
    }
}
