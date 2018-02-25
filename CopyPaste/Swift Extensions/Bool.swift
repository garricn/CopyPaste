//
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public extension Bool {
    init?(string: String) {
        switch string {
        case "true":
            self = true
        case "false":
            self = false
        default:
            return nil
        }
    }
}
