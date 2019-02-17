//
//  SignUpViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SignUpViewController: Controller<
    SignUpControllerView,
    SignUpControllerViewModel
>  {

    // MARK: Properties

    // MARK: Callbacks
    var doneCallback: EmptyClosure?

    // MARK: Configuration

    override func configureView() {
        super.configureView()
        rootView.selectUserAvatarView.setTitle = "ADD"
        rootView.selectUserAvatarView.didSelectImage = { [unowned self] in
            ImagePicker { picker in
                picker.didPickImage = { [unowned self] image in
                    self.rootView.selectUserAvatarView.setImage = image
                }
                }.show(from: self)
        }
    }

    override func configureViewModel() {
        super.configureViewModel()

    }
}
