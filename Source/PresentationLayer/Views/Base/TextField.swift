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
    }

    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5)

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
    }

    private func getAttributedPlaceholder(withText text: String) -> NSAttributedString {
        return NSAttributedString(string: text ,
                                  attributes: [NSAttributedString.Key.foregroundColor: Constants.placeholderColor,
                                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]) // Constants.
    }
}

