//
//  EditViewController.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/6/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class EditViewController: UIViewController {
    
    weak var delegate: EditViewControllerDelegate?
    
    private let textView = UITextView()
    private let item: String
    
    init(itemToEdit: String) {
        self.item = itemToEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelAction = #selector(didTapCancelBarButtonItem)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: cancelAction)
        
        let saveAction = #selector(didTapSaveBarButtonItem)
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: saveAction)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.insertText(item)
        textView.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapCancelBarButtonItem(sender: UIBarButtonItem) {
        delegate?.didCancelEditing(item, in: self)
    }
    
    @objc private func didTapSaveBarButtonItem(sender: UIBarButtonItem) {
        if textView.text.isEmpty {
            delegate?.didCancelEditing(item, in: self)
        } else {
            delegate?.didFinishEditing(textView.text, in: self)
        }
    }
}

protocol EditViewControllerDelegate: class {
    func didCancelEditing(_ item: String, in viewController: EditViewController)
    func didFinishEditing(_ item: String, in viewController: EditViewController)
}
