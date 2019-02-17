//
//  ImagePickerAction.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/16/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

final class ImagePickerAction {

    // MARK: Properties

    let name: String
    var didPress: EmptyClosure?


    // MARK: - Initialization

    init(
        name: String,
        didPress: EmptyClosure?
        ) {
        self.name = name
        self.didPress = didPress
    }
}
