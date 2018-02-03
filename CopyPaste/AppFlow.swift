//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public protocol Flow {}

public enum FlowType {
    case app(AppFlow)
    case foreground(ForegroundFlow)
    case background(BackgroundFlow)
    case welcome(WelcomeViewController)
    case copy(CopyFlow)

    static func children(for flowTypes: [FlowType]) -> [FlowKey: Flow] {
        var children: [FlowKey: Flow] = [:]

        for flowType in flowTypes {
            switch flowType {
            case let .app(flow):
                children[.app] = flow
            case let .foreground(flow):
                children[.foreground] = flow
            case let .background(flow):
                children[.background] = flow
            case let .welcome(flow):
                children[.welcome] = flow
            case let .copy(flow):
                children[.copy] = flow
            }
        }

        return children
    }

    public enum FlowKey {
        case app
        case foreground
        case background
        case welcome
        case copy
        private init() { fatalError() }
    }
}

public final class AppContext: ForegroundDependencyProvider {
    public let makeForegroundFlow: (ForegroundDependencyProvider) -> ForegroundFlow = { provider in return .init(provider: provider) }
    public let makeBackgroundFlow: () -> BackgroundFlow = { BackgroundFlow.init() }
    public let makeDataContext: () -> CopyContext<Item> = { CopyContext<Item>.init() } // rename copy context

    // MARK: - Foreground Dependency Provider
    public let makeRootViewController: () -> AppViewController = { AppViewController() }
    public let makeDefaultsContext: () -> DefaultsContext = { DefaultsContext() }
    public let makeCopyFlow: () -> CopyFlow = { CopyFlow.init() }

    public init() {}
}

public final class AppFlow: Flow {

    let context: AppContext = AppContext()

    public private(set) var children: [FlowType.FlowKey: Flow] = [:]
    public private(set) var window: UIWindow?


    public init(window: UIWindow? = nil) {
        self.window = window
    }

    private(set) lazy var foregroundFlow: ForegroundFlow = context.makeForegroundFlow(context)
    private(set) lazy var backgroundFlow: BackgroundFlow = context.makeBackgroundFlow()

    public private(set) var launch: Launch!

    public func willFinish(_ launch: Launch) -> Bool {
        self.launch = launch

        switch launch.kind {
        case .foreground:
            window = UIWindow()
            window!.rootViewController = foregroundFlow.rootViewController
            window!.makeKeyAndVisible()
        case .background:
            fatalError()
        }

        return true
    }

    public func didFinish(_ launch: Launch) -> Bool {
        assert(launch.kind == self.launch.kind)

        switch launch.kind {
        case .foreground:
            children = FlowType.children(for: [.foreground(foregroundFlow)])
            return foregroundFlow.didStart(for: launch.reason)
        case .background:
            fatalError()
        }
    }

    @discardableResult
    public func performAction(for shortcutItem: UIApplicationShortcutItem, completion: @escaping (Bool) -> Void) -> Bool {
        assert(window?.rootViewController != nil)

        if let item = ShortcutItem(item: shortcutItem, completion: completion) {
            foregroundFlow.performAction(for: item)
            return true
        } else {
            return false
        }
    }
}
