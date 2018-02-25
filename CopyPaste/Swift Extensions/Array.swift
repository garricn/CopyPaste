//
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public extension Array {
    func element(at index: Int) -> Element? {
        if isEmpty || index > count {
            return nil
        } else {
            return self[index]
        }
    }
}
