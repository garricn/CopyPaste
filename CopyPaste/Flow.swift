//
//  Flow.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

protocol Flow {
    func start(with parentViewController: UIViewController)
    func applicationWillTerminate()
}

extension Flow {
    func add(_ child: UIViewController, to parent: UIViewController) {
        parent.addChildViewController(child)
        parent.view.addSubview(child.view)
        child.didMove(toParentViewController: parent)
    }
}
