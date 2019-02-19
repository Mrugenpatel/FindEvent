//
//  SettingsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {


    private var viewModel: SettingsControllerViewModel?

    convenience init(viewModel: SettingsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }


    // MARK: Callbacks
    var doneCallback: EmptyClosure?
}
