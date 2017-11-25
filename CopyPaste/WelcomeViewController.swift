//
//  WelcomeViewController.swift
//  CopyPaste
//
//  Created by Garric G. Nahapetian on 11/24/17.
//  Copyright © 2017 SwiftCoders. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    private var didTapGetStarted: (() -> Void)?

    private let label: UILabel = .init()
    private let button: UIButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(label)
        label.text = "Welcome"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(button)
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didTap(getStartedButton:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func onDidTapGetStarted(perform action: @escaping (() -> Void)) {
        didTapGetStarted = action
    }

    @objc
    private func didTap(getStartedButton: UIButton) {
        didTapGetStarted?()
    }
}
