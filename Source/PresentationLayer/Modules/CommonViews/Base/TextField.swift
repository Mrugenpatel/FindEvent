//
//  TextField.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/13/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class TextField: UITextField {

    private struct Constants {
        static let backgroundColor = ViewConfig.Colors.grey
        static let textColor = ViewConfig.Colors.textWhite
        static let placeholderColor = ViewConfig.Colors.textLightGrey
        static let caretColor = ViewConfig.Colors.white
        static let textFont = Font.bold(of: 14)
    }

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    private var customPlaceholder: String? = ""

    override var placeholder: String? {
        get {
            return customPlaceholder
        }
        set {
            customPlaceholder = newValue
            attributedPlaceholder = getAttributedPlaceholder(withText: newValue ?? "")
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = Constants.backgroundColor
        textColor = Constants.textColor
        tintColor = Constants.caretColor
        font = Font.bold(of: 16)
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
    }

    private func getAttributedPlaceholder(withText text: String) -> NSAttributedString {
        return NSAttributedString(string: text ,
                                  attributes: [NSAttributedString.Key.foregroundColor: Constants.placeholderColor,
                                               NSAttributedString.Key.font: Constants.textFont])
    }
}

