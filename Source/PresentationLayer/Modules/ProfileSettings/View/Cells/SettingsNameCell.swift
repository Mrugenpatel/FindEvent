//
//  SettingsNameCell.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/28/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SettingsNameCell: TableViewCell {

    // MARK: - Callbacks

    var editedName: ((String)->Void)?

    // MARK: - Views

    lazy var textField = configuredTextField()

    // MARK: - Configuration

    override func configure() {
        super.configure()
        contentView.backgroundColor = ViewConfig.Colors.background
        selectionStyle = .none
        attachTextField()
    }

    func configure(name: String) {
        if !name.isEmpty {
            textField.text = name
        }
    }

    private func configuredTextField() -> TextField {
        let textField = TextField()
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.placeholder = "Name"

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

extension SettingsNameCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(
        _ textField: UITextField
        ) {
        textField.text = ""
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        editedName?(updatedString ?? "")
        return true
    }
}
