//
//  Controller.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class Controller<
    RootView: ControllerView,
    ViewModel: ControllerViewModel
>: ViewController {

    // MARK: - Properties
    // MARK: ViewModel

    let viewModel: ViewModel

    // MARK: View

    let rootView: RootView


    // MARK: - Initialization

    init(
        rootView: RootView = .init(),
        viewModel: ViewModel
        ) {
        self.rootView = rootView
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil // No needed
    }


    // MARK: - View lifecycle

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.didLayoutSubviews()
    }


    // MARK: - ViewModel
    // MARK: Configuration

    func configureViewModel() {
        viewModel.configure()
    }
}

