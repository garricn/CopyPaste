//
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    enum Action {
        case adding
        case editing(Item, at: IndexPath)
        var title: String {
            switch self {
            case .adding:
                return "Add Item"
            case .editing:
                return "Edit Item"
            }
        }
        var item: Item {
            switch self {
            case .adding:
                return Item()
            case .editing(let item, _):
                return item
            }
        }
    }

    private let textView = UITextView()
    private let item: Item

    private var didTapCancelWhileEditing: ((_ item: Item, _ viewController: EditItemViewController) -> Void)?
    private var didTapSaveWhileEditing: ((_ item: Item, _ viewController: EditItemViewController) -> Void)?

    init(action: Action) {
        self.item = action.item
        super.init(nibName: nil, bundle: nil)
        self.title = action.title
    }

    override func loadView() {
        view = textView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureTextView()
    }

    required init?(coder aDecoder: NSCoder) {
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

    private func configureTextView() {
        textView.accessibilityLabel = "Body"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.insertText(item.body)
        textView.becomeFirstResponder()
    }

    func onDidTapCancelWhileEditing(perform action: @escaping ((Item, EditItemViewController) -> Void)) {
        didTapCancelWhileEditing = action
    }

    func onDidTapSaveWhileEditing(perform action: @escaping ((Item, EditItemViewController) -> Void)) {
        didTapSaveWhileEditing = action
    }

    @objc private func didTap(cancelBarButtonItem: UIBarButtonItem) {
        didTapCancelWhileEditing?(item, self)
    }

    @objc private func didTap(saveBarButtonItem: UIBarButtonItem) {
        let item = Item(body: textView.text, copyCount: self.item.copyCount)
        didTapSaveWhileEditing?(item, self)
    }
}
