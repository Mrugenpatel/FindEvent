//
//  UserService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserServiceType {

    typealias UserResult = (Result<User, UserServiceError>)

    func create(
        user: User,
        completion: @escaping (Result<User, UserServiceError>) -> Void
    )

    func updateById(
        user: User,
        completion: @escaping (Result<User, UserServiceError>) -> Void
    )

    func getById(
        userId: String,
        completion: @escaping (Result<User, UserServiceError>) -> Void
    )

    func getAll(
        completion: @escaping (Result<[User], UserServiceError>) -> Void
    )

    func getAllByIds(
        usersId: [String],
        completion: @escaping (Result<[User], UserServiceError>) -> Void
    )
}

class UserService: UserServiceType {

    private struct CollectionKeys {
        static let users = "users"
        static let userId = "userId"
    }

    private let userCollection = Firestore.firestore().collection(CollectionKeys.users)

    func create(
        user: User,
        completion: @escaping (Result<User, UserServiceError>) -> Void
        ) {
        guard let userId = user.id else { completion(.failure(.emptyId)); return }
        userCollection.document(userId).setData(user.data()) { responseError in
            guard let firebaseError = responseError else { completion(.success(user)); return }
            let error = UserServiceError.getError(from: firebaseError)
            completion(Result.failure(error))
        }
    }

    func updateById(
        user: User,
        completion: @escaping (Result<User, UserServiceError>) -> Void
        ) {
        guard let userId = user.id else { completion(.failure(.emptyId)); return }
        userCollection.document(userId).updateData(user.data()) { responseError in
            guard let firebaseError = responseError else { completion(.success(user)); return }
            let error = UserServiceError.getError(from: firebaseError)
            completion(.failure(error))
        }
    }

    func getById(
        userId: String,
        completion: @escaping (Result<User, UserServiceError>) -> Void
        ) {
        userCollection.document(userId).getDocument(completion: { (responseData, responseError) in
            guard let firebaseError = responseError else {
                guard let data = responseData?.data() else { completion(.failure(.mappingFailed)); return }
                guard let user = User(user: data) else { completion(.failure(.mappingFailed)); return }
                completion(.success(user)); return }
            completion(.failure(UserServiceError.getError(from: firebaseError)))
        })
    }

    func getAll(
        completion: @escaping (Result<[User], UserServiceError>) -> Void
        ) {
        userCollection.getDocuments { (responseData, responseError) in
            if let users = responseData?.documents.compactMap({ docs in
                docs.data().flatMap({ data in return User(user: data) })
            }) {
                users.isEmpty ? completion(.failure(.isEmpty)) : completion(.success(users))
            } else {
                guard let firebaseError = responseError else { completion(.failure(.notFound)); return }
                let error = UserServiceError.getError(from: firebaseError)
                completion(.failure(error))
            }
        }
    }

    func getAllByIds(
        usersId: [String],
        completion: @escaping (Result<[User], UserServiceError>) -> Void
        ) {
        userCollection.getDocuments { (responseData, responseError) in
            if let users = responseData?.documents.compactMap({ docs in
                docs.data().flatMap({ (data) in return User(user: data) })
            }).filter({ usersId.contains($0.id!) }) {
                users.isEmpty ? completion(.failure(.isEmpty)) : completion(.success(users))
            } else {
                guard let firebaseError = responseError else { completion(.failure(.notFound)); return }
                let error = UserServiceError.getError(from: firebaseError)
                completion(.failure(error))
            }
        }
    }

    static func setUserStatus(
        isOnline: Bool
        ) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userCollection = Firestore.firestore().collection("users")
        userCollection.document(currentUser.uid).setData(["lastOnlineDate": isOnline], merge: true)
    }
}
