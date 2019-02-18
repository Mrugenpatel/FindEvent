//
//  SignUpControllerView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SnapKit

final class SignUpControllerView: ControllerView {

    // MARK: - Properties
    // MARK: Callbacks

    var didTouchSignUpViaFB: EmptyClosure?
    var didTouchSignUpViaEmail: EmptyClosure?

    // MARK: Views

    lazy var selectUserAvatarView = SelectUserAvatarView()

    lazy var signUpEmailButton = configuredEmailButton()

    // MARK: - UI
    // MARK: Configuration

    override func configure() {
        super.configure()
        attachUserAvatarView()
        attachEmailButton()
    }

    private func configuredEmailButton() -> Button {
        let button = Button()
        button.didTouchUpInside = { [unowned self] in
            self.didTouchSignUpViaEmail?()
        }
        return button
    }

    private func attachUserAvatarView() {
        containerView.addSubview(selectUserAvatarView)
        selectUserAvatarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(160)
        }
    }

    private func attachEmailButton() {
        containerView.addSubview(signUpEmailButton)
        signUpEmailButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
