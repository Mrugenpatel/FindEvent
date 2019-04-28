//
//  FriendsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    private var viewModel: FriendsControllerViewModel?

    convenience init(viewModel: FriendsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}
