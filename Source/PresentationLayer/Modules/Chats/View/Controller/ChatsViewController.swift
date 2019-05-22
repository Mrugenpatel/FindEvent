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
            action: #selector(addChat))
    }
    
    // MARK: Actions
    
    @objc func addChat() {
        //viewModel.saveEditedInfo()
    }
}
