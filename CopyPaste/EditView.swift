//
//  Copyright © 2018 SwiftCoders. All rights reserved.
//

import UIKit

public final class EditView: UIView {

    public let titleTextField: UITextField = {
        let textField = UITextField()
        textField.accessibilityLabel = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title (Optional)"
        textField.textColor = .black
        textField.contentVerticalAlignment = .top
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
        textField.autocapitalizationType = .words
        return textField
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()

    public let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.accessibilityLabel = "Body"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.text = "Body"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layoutMargins = UIEdgeInsets.zero
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }()

    public init() {
        super.init(frame: CGRect.zero)

        backgroundColor = .white

        addSubview(titleTextField)
        addSubview(separatorView)
        addSubview(bodyTextView)

        let titleConstraints = [
            NSLayoutConstraint(
                item: titleTextField,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leadingMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: titleTextField,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailingMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: titleTextField,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .topMargin,
                multiplier: 1.0,
                constant: 10
            )
        ]

        let separatorConstraints = [
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            NSLayoutConstraint(
                item: separatorView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leadingMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: separatorView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailingMargin,
                multiplier: 1.0,
                constant: 0
            )
        ]

        let bodyConstraints = [
            bodyTextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            NSLayoutConstraint(
                item: bodyTextView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottomMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: bodyTextView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leadingMargin,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: bodyTextView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailingMargin,
                multiplier: 1.0,
                constant: 0
            )
        ]

        NSLayoutConstraint.activate(
            titleConstraints
                + separatorConstraints
                + bodyConstraints
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
