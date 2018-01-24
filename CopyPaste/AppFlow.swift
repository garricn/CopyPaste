//
//  AppFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 1/25/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public protocol Flow {
//    var identifier: String { get }
//    var parent: Flow { get }
//    var children: [FlowType] { get }
}

extension UIApplication: Flow {}

public enum FlowType {
    case app(AppFlow)
    case foreground(ForegroundFlow)
    case background(BackgroundFlow)
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

    public let identifier: String
    public let parent: Flow

    public private(set) var children: [FlowType.FlowKey: Flow] = [:]
    public private(set) var window: UIWindow?

    let context: AppContext

    public init(window: UIWindow?,
                context: AppContext = AppContext(),
                parent: Flow = UIApplication.shared,
                identifer: String = String(describing: AppFlow.self)) {
        self.context = context
        self.window = window
        self.parent = parent
        self.identifier = identifer
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
            _ = didStartChildFlows(for: launch)
            return foregroundFlow.didStart(for: launch.reason)
        case .background:
            fatalError()
        }
    }

    public func didStartChildFlows(for launch: Launch) -> [FlowType.FlowKey: Flow] {
        assert(launch.kind == self.launch.kind)

        switch launch.kind {
        case .foreground:
            children = FlowType.children(for: [.foreground(foregroundFlow)])
            return children
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
