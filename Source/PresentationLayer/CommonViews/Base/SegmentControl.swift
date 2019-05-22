//
//  SegmentControl.swift
//  FamillyOrganizer
//
//  Created by Yuriy Tsymbala on 5/22/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class SegmentControl: UISegmentedControl {
    
    private struct Constants {
        static let backgroundColor = ViewConfig.Colors.background
        static let selectedColor = ViewConfig.Colors.blue
        static let textColor = ViewConfig.Colors.textWhite
        //static let textFont = UIFont.
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    private func setup() {
        tintColor = Constants.selectedColor
        backgroundColor = Constants.backgroundColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.textColor,
                                   NSAttributedString.Key.font: ViewConfig.Fonts.semiboldItalic(of: 15)]
        self.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}
