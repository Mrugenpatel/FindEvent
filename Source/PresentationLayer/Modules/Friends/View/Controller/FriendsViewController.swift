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
        navigationController?.isNavigationBarHidden = false
    }
}
