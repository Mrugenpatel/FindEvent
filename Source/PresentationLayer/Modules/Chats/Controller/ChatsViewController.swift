//
//  ChatsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    private var viewModel: ChatsControllerViewModel?

    convenience init(viewModel: ChatsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}
