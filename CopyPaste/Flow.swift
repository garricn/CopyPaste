//
//  Flow.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

protocol Flow {
    func start(with parent: UIViewController)
    func applicationWillTerminate()
}
