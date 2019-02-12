//
//  SignInControllerView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SnapKit

final class SignInControllerView: ControllerView {

    // MARK: - Properties
    // MARK: Callbacks

    var didTouchCreateAccount: EmptyClosure?
    var didTouchSignIn: EmptyClosure?
    var doneCallback: (() -> Void)?

    // MARK: Views


    // MARK: - UI
    // MARK: Configuration

    override func configure() {
        super.configure()
    }
}
