//
//  SettingsLocationCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/28/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreLocation

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
        attachSwitcher()
        attachTextField()
    }

    func configure(location: GeoPoint?) {
        guard
            let location = location
            else {
                locationSwitcher.isOn = false
                textField.text = nil
                return }
        locationSwitcher.isOn = true
        getPlace(for: CLLocation(
            latitude: location.latitude,
            longitude: location.longitude)) { [weak self] placemark in
                self?.textField.text = String().formattedAddress(fromPlacemark: placemark)
        }
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
        switcher.onTintColor = ViewConfig.Colors.dark
        switcher.tintColor = ViewConfig.Colors.dark
        switcher.thumbTintColor = ViewConfig.Colors.blue

        return switcher
    }

    // MARK: - Actions

    @objc
    private func onSwitchValueChanged(_ sender: UISwitch) {
        sender.isOn ? showLocation?(true) : showLocation?(false)
    }

    // MARK: - Attachments

    private func attachSwitcher() {
        contentView.addSubview(locationSwitcher)

        locationSwitcher.snp.makeConstraints { maker in
            maker.top.right.equalToSuperview().inset(5)
            maker.height.equalTo(30)
        }
    }

    private func attachTextField() {
        contentView.addSubview(textField)

        textField.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(5)
            maker.right.equalTo(locationSwitcher.snp.left).offset(3)
            maker.centerY.equalTo(locationSwitcher)
            maker.height.equalTo(30)
        }
    }
}

extension SettingsLocationCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showMap?()
    }
}
