//
//  BackgroundFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/24/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public final class BackgroundFlow: Flow {
    public init() {}
    func didFinish(_ launch: Launch) -> Bool { return false }
}
