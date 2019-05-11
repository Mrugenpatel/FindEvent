//
//  SettingsLocationCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/28/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SettingsLocationCell: TableViewCell {

    // MARK: - Callbacks

    var showMap: EmptyClosure?
    var showLocation: ((Bool) -> ())?
    
    // MARK: - Views

    lazy var textField = configuredTextField()
    lazy var locationSwitcher = configuredLocationSwitcher()

    // MARK: - Configuration

    override func configure() {
        super.configure()
        contentView.backgroundColor = ViewConfig.Colors.background
        selectionStyle = .none
        attachTextField()
        attachSwitcher()
    }

    func configure(location: GeoPoint?) {
        guard
            let location = location
        else {
            locationSwitcher.isOn = false
            textField.text = nil
            return }
        locationSwitcher.isOn = true
        textField.text = String(location.latitude)
        
        //        if !location.isEmpty {
        //            textField.text = location
        //        }
    }

    private func configuredTextField() -> TextField {
        let textField = TextField()
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.placeholder = "Location"

        return textField
    }

    private func configuredLocationSwitcher() -> UISwitch {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .touchUpInside)

        return switcher
    }

    // MARK: - Actions

    @objc
    private func onSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? showLocation?(true) : showLocation?(false)
    }

    // MARK: - Attachments

    private func attachTextField() {
        contentView.addSubview(textField)

        textField.snp.makeConstraints { maker in
            maker.left.top.equalToSuperview().inset(5)
            maker.height.equalTo(30)
        }
    }

    private func attachSwitcher() {
        contentView.addSubview(locationSwitcher)

        locationSwitcher.snp.makeConstraints { maker in
            maker.centerY.equalTo(textField)
            maker.left.equalTo(textField.snp.right)
            maker.right.equalToSuperview().inset(10)
            maker.height.equalTo(30)
        }
    }
}

extension SettingsLocationCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showMap?()
    }
}
