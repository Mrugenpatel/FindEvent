//
//  ProfileSettingsSection.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 4/28/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

enum ProfileSettingsSection: String, CaseIterable {

    // MARK: - Cases

    case avatarSection = "Choose or Change Image"
    case nameSection = "Please enter your real name"
    case locationSection = "Show current location for friends"
    case descriptionSection = "Describe yourself (hobbies,profession,age)"
    case logoutSection = ""
}
