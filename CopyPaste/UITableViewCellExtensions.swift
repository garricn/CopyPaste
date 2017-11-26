//
//  UITableViewCellExtensions.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/26/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
