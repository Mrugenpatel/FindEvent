//
//  GameViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    private var viewModel: GameControllerViewModel?

    convenience init(viewModel: GameControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

}
