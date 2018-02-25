//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

public struct EditViewModel {
    let title: String?
    let body: String?
}

public final class EditViewController: UIViewController {

    private let editItemView: EditView = .init()
    private let viewModel: EditViewModel

    private var didTapCancelWhileEditing: (() -> Void)?
    private var didTapSaveWhileEditing: ((_ title: EditViewModel) -> Void)?

    private var titleTextField: UITextField { return editItemView.titleTextField }
    private var bodyTextView: UITextView { return editItemView.bodyTextView }

    public init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public override func loadView() {
        view = editItemView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureNavigationItem() {
        let cancelAction = #selector(didTap(cancelBarButtonItem:))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: cancelAction)
        navigationItem.leftBarButtonItem = cancelButton

        let saveAction = #selector(didTap(saveBarButtonItem:))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: saveAction)
        navigationItem.rightBarButtonItem = saveButton
    }

    private func configureView() {
        titleTextField.text = viewModel.title
        bodyTextView.text = viewModel.body
        bodyTextView.becomeFirstResponder()
    }

    public func onDidTapCancelWhileEditing(perform action: @escaping () -> Void) {
        didTapCancelWhileEditing = action
    }

    public func onDidTapSaveWhileEditing(perform action: @escaping (EditViewModel) -> Void) {
        didTapSaveWhileEditing = action
    }

    @objc private func didTap(cancelBarButtonItem: UIBarButtonItem) {
        didTapCancelWhileEditing?()
    }

    @objc private func didTap(saveBarButtonItem: UIBarButtonItem) {
        let body = bodyTextView.text
        let title = titleTextField.text
        let item = EditViewModel(title: title, body: body)
        didTapSaveWhileEditing?(item)
    }
}
