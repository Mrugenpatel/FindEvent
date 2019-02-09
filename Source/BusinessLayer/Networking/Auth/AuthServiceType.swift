//
//  AuthServiceType.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

protocol AuthServiceType {

    typealias AuthHandler = (Result<User, AuthServiceError>) -> Void

    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void)

    var currentUserId: String? { get }
}
