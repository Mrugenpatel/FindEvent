//
//  ControllerView.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import SnapKit

class ControllerView: UIView {

    // MARK: - Properties
    // MARK: Views

    lazy var containerView = configuredContainerView()


    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil // No needed
    }


    // MARK: - UI
    // MARK: Configuration

    func configure() {
        backgroundColor = .white

        attachContainerView()
    }

    func didLayoutSubviews() {

    }

    func configuredContainerView() -> View {
        return .init()
    }

    // MARK: Attachments
    
    func attachContainerView() {
        addSubview(containerView)

        containerView.snp.makeConstraints { maker in
            if #available(iOS 11.0, *) {
                maker.edges.equalTo(safeAreaLayoutGuide)
            } else {
                maker.edges.equalToSuperview()
            }
        }
    }
}

