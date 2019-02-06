//
//  Types.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

// MARK: - All

typealias EmptyClosure = () -> Void
typealias ErrorClosure = (Error?) -> Void
typealias DidTouchUpInside = () -> Void

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)

    var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

