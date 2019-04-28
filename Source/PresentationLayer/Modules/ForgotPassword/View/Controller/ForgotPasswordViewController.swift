//
//  ForgotPasswordViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/7/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    private var viewModel: SignUpControllerViewModelType!

    convenience init(viewModel: SignUpControllerViewModelType) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
