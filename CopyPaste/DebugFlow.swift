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
    
    public func start(presenter: UIViewController) {
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
