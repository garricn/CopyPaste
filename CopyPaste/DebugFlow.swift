//
//  DebugFlow.swift
//  CopyPaste
//
//  Created by Garric Nahapetian on 4/1/18.
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public final class DebugFlow {
    
    lazy var itemsContext: DataContext<[Item]> = AppContext.shared.itemsContext
    lazy var defaultsContext: DataContext<Defaults> = AppContext.shared.defaultsContext
    
    private var didGetItems: (([Item]) -> Void)?
    
    public func start(presenter: UIViewController) {
        let alert = UIAlertController(title: "DEBUG", message: nil, preferredStyle: .actionSheet)
        
        let dataTitle = "Load"
        let dataHandler: (UIAlertAction) -> Void  = { _ in self.load() }
        let dataAction = UIAlertAction(title: dataTitle, style: .destructive, handler: dataHandler)
        dataAction.accessibilityLabel = "resetData"
        alert.addAction(dataAction)
        
        let defaultsTitle = "Reset"
        let defaultsHandler: (UIAlertAction) -> Void  = { _ in self.presentReset(presenter: presenter) }
        let defaultsAction = UIAlertAction(title: defaultsTitle, style: .destructive, handler: defaultsHandler)
        defaultsAction.accessibilityLabel = "resetDefaults"
        alert.addAction(defaultsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.accessibilityLabel = "cancel"
        alert.addAction(cancelAction)
        
        presenter.present(alert, animated: true, completion: nil)
    }
    
    public func onGet(perform action: @escaping ([Item]) -> Void) {
        didGetItems = action
    }
    
    private func load() {
        let url = Bundle.main.url(forResource: "sampleItems", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let items = try! JSONDecoder().decode([Item].self, from: data)
        didGetItems?(items)
    }
    
    private func presentReset(presenter: UIViewController) {
        let alert = UIAlertController(title: "RESET", message: nil, preferredStyle: .actionSheet)
        
        let dataTitle = "Data"
        let dataHandler: (UIAlertAction) -> Void  = { _ in self.itemsContext.reset() }
        let dataAction = UIAlertAction(title: dataTitle, style: .destructive, handler: dataHandler)
        dataAction.accessibilityLabel = "resetData"
        alert.addAction(dataAction)
        
        let defaultsTitle = "Defaults"
        let defaultsHandler: (UIAlertAction) -> Void  = { _ in self.defaultsContext.reset() }
        let defaultsAction = UIAlertAction(title: defaultsTitle, style: .destructive, handler: defaultsHandler)
        defaultsAction.accessibilityLabel = "resetDefaults"
        alert.addAction(defaultsAction)
        
        let bothTitle = "Both"
        let bothHandler: (UIAlertAction) -> Void  = { _ in self.itemsContext.reset(); self.defaultsContext.reset() }
        let bothAction = UIAlertAction(title: bothTitle, style: .destructive, handler: bothHandler)
        bothAction.accessibilityLabel = "resetDataAndDefaults"
        alert.addAction(bothAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.accessibilityLabel = "cancel"
        alert.addAction(cancelAction)
        
        presenter.present(alert, animated: true, completion: nil)
    }
}
