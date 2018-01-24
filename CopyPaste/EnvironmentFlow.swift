//
//  EnvironmentFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/24/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import Foundation

public final class EnvironmentFlow {

    public func didFinishLaunch(_ commandLineType: CommandLine.Type, _ launchOptions: Options?) -> Launch {
        var arguments = commandLineType.arguments
        _ = arguments.removeFirst()
        let launchArguments = arguments.flatMap { Launch.Argument(rawValue: $0) }
        let isUITesting = launchArguments.contains(.isUITesting)
        let launch = isUITesting ? Launch(arguments: launchArguments) : Launch(options: launchOptions)
        return launch
    }
}
