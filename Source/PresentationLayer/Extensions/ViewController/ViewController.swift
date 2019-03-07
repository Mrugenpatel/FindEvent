//
//  ViewController.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/19/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func configureViewModel() {}
    @objc func configureView() {}
    var containerView: UIView {
        return view
    }

    @objc func enableUserIteraction(isUserInteractionEnabled: Bool) {
        containerView.isUserInteractionEnabled = isUserInteractionEnabled
    }
}
