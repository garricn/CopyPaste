//
//  TableViewCell.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 5/13/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {

    static let identifier = String(describing: TableViewCell.self)

    // MARK: - Accessibility

    override var isAccessibilityElement: Bool {
        get { return true }
        set {}
    }

    var bodyText: String? {
        get {
            return bodyLabel.text
        }
        set {
            let string = NSLocalizedString(newValue ?? "", comment: "")
            bodyLabel.text = string
            accessibilityLabel = string
        }
    }

    var countText: String? {
        get {
            return countLabel.text
        }
        set {
            countLabel.text = NSLocalizedString(newValue ?? "", comment: "")
        }
    }

    private let containerView = UIView()
    private let bodyLabel = UILabel()
    private let countLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        accessibilityTraits |= UIAccessibilityTraitButton

        isAccessibilityElement = true
        configureContainerView()
        configureBodyLabel()
        configureCountLabel()
        configureCommonConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5.0
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureBodyLabel() {
        containerView.addSubview(bodyLabel)
        bodyLabel.numberOfLines = 0
        bodyLabel.accessibilityLabel = "Body"
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            bodyLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private func configureCountLabel() {
        containerView.addSubview(countLabel)
        countLabel.numberOfLines = 1
        countLabel.accessibilityLabel = "Copy Count"
        countLabel.textColor = .lightGray
        countLabel.setContentHuggingPriority(751, for: .vertical)
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            countLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            countLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            countLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureCommonConstraints() {
        NSLayoutConstraint.activate(
            [
                bodyLabel.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -4)
            ]
        )
    }

    private let duration: TimeInterval = 0.4

    override func setSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: duration) {
                self.containerView.backgroundColor = selected ? .gray : .white
            }
        } else {
            containerView.backgroundColor = selected ? .gray : .white
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: duration) {
                self.containerView.backgroundColor = highlighted ? .gray : .white
            }
        } else {
            containerView.backgroundColor = highlighted ? .gray : .white
        }
    }
}
