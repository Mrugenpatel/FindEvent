//
//  UserService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/9/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

//class UserService {
//    // update image
//    // update location
//}

import Foundation
import FirebaseFirestore

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
        let userRef = userCollection.document(userId)
        userRef.updateData(user.data()) { responseError in
            guard let firebaseError = responseError else { completion(.success(user)); return }
            let error = UserServiceError.getError(from: firebaseError)
            completion(.failure(error))
        }
    }

    func getById(
        userId: String,
        completion: @escaping (Result<User, UserServiceError>) -> Void
        ) {
        //        return Observable<UserResult>.create({ [weak self] observer in
        //        self?.fireDbUsersRef
        //        .document(userId)
        //        .addSnapshotListener({ (query, error) in
        //        guard let error = error else {
        //        guard let data = query?.data() else { observer.onNext(.failure(.mappingFailed)); return }
        //        guard let user = User(user: data) else { observer.onNext(.failure(.mappingFailed)); return }
        //        observer.onNext(.success(user))
        //        return
        //        }
        //        let err = UserServiceError.getError(from: error)
        //        observer.onNext(.failure(err))
        //        })
        //        return Disposables.create()
        //        })
    }

    func getAll(
        completion: @escaping (Result<[User], UserServiceError>) -> Void
        ) {
        userCollection.getDocuments { (documents, responseError) in
            if let users = documents?.documents.compactMap({ docs in
                docs.data().flatMap({ data in
                    return User(user: data)
                })
            }) {
                users.isEmpty ? completion(.failure(.isEmpty)) : completion(.success(users))
            } else {
                guard let firebaseError = responseError else { completion(.failure(.notFound)); return }
                let err = UserServiceError.getError(from: firebaseError)
                completion(.failure(err))
            }
        }
    }

    func getAllByIds(
        usersId: [String],
        completion: @escaping (Result<[User], UserServiceError>) -> Void
        ) {
        userCollection.getDocuments { (documents, error) in
            if let users = documents?.documents.compactMap({ docs in
                docs.data().flatMap({ (data)  in
                    return User(user: data)
                })
            }).filter({ usersId.contains($0.id!) }) {
                users.isEmpty ? completion(.failure(.isEmpty)) : completion(.success(users))
            } else {
                guard let error = error else { completion(.failure(.notFound)); return }
                let err = UserServiceError.getError(from: error)
                completion(.failure(err))
            }
        }
    }
}
