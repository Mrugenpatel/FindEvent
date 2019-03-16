//
//  Reusable.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 3/8/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
