//
//  EventsViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/12/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {


    private var viewModel: EventsControllerViewModel?

    convenience init(viewModel: EventsControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}
