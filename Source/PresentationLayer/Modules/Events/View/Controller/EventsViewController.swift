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
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configuredNavigationBar()
    }
    
    // MARK: Configuration
    
    override func configureView() {
        super.configureView()
        containerView.backgroundColor = ViewConfig.Colors.background
    }
    
    override func configureViewModel() {
        super.configureViewModel()
    }
    
    private func configuredNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEvent))
    }
    
    // MARK: Actions
    
    @objc func addEvent() {
        //viewModel.saveEditedInfo()
    }
}
