//
//  SettingsLocationCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/28/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsLocationCell: TableViewCell {

    // MARK: - Callbacks

    var showMap: EmptyClosure?
    
    // MARK: - Views

    lazy var textField = configuredTextField()

    // MARK: - Configuration

    override func configure() {
        super.configure()
        contentView.backgroundColor = ViewConfig.Colors.background
        selectionStyle = .none
        attachTextField()
    }

    func configure(location: Coordinate?) {
//        if !location.isEmpty {
//            textField.text = location
//        }
    }

    private func configuredTextField() -> TextField {
        let textField = TextField()
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.placeholder = "Location"

        return textField
    }


    // MARK: - Actions

    // MARK: - Attachments

    private func attachTextField() {
        contentView.addSubview(textField)

        textField.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview().inset(5)
            maker.height.equalTo(30)
        }
    }
}

extension SettingsLocationCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showMap?()
    }
}
