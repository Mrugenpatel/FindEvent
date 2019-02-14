//
//  ImageServiceError.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/14/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseStorage

enum ImageServiceError {
    case unknown
    case internalError(NSError)
    case objectNotFound
    case userIdNil
    case userIdEmpty
    case urlSessionError
    case imageNil
    case avatarImgURLNil

    case invalidURL
    case failedToDownloadData
    case invalidData

    public static func getImageServiceError(from error: Error) -> ImageServiceError {
        guard let imgError = error as NSError?,
            let firebaseError = StorageErrorCode(rawValue: imgError.code)
            else { return .unknown }

        switch firebaseError {
        case .objectNotFound: return .objectNotFound
        default:
            return .internalError(imgError)
        }
    }
}
