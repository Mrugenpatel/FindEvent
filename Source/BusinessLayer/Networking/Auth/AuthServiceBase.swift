//
//  AuthServiceBase.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/14/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthServiceType {

    typealias AuthResult = (Result<User, AuthServiceError>) -> Void

    func signOut(
        completion: @escaping (Result<Bool, AuthServiceError>) -> Void
    )
}

