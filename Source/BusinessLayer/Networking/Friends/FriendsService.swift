//
//  FriendsService.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 5/19/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FriendsServiceType {

    typealias FriendsResult = (Result<[User], FriendsServiceError>)
    typealias RequestResult = (Result<Bool, FriendsServiceError>)
    
    func getFriends(
        completion: @escaping (FriendsResult) -> Void
    )
    
    func getSent(
        completion: @escaping (FriendsResult) -> Void
    )
    
    func getRequests(
        completion: @escaping (FriendsResult) -> Void
    )
    
    func approveRequest(
        completion: @escaping (RequestResult) -> Void
    )
    
    func declineRequest(
        completion: @escaping (RequestResult) -> Void
    )
    
    func sentRequest(
        completion: @escaping (RequestResult) -> Void
    )
}

class FriendsService: FriendsServiceType {
    private struct CollectionKeys {
        static let friendsCollection = "users"
        static let friendRequests = "friend_requests"
        static let receiver = "receiver"
        static let sender = "sender"
        static let status = "status"
    }

    private let friendsCollection = Firestore.firestore().collection(CollectionKeys.friendRequests)
    private let friendsRequestsCollection = Firestore.firestore().collection(CollectionKeys.friendRequests)

    private let usersService: UserService

    init(usersService: UserService) {
        self.usersService = usersService
    }

    func getFriends(
        completion: @escaping (FriendsResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        friendsCollection.document(currentUserID).collection("friends").getDocuments { (documentsArray, error) in
            guard let friendDocuments = documentsArray else {return}
            if friendDocuments.documents.isEmpty {
                completion(Result.success([]))
                return
            }
            
             var users = [User]()
            
            for friendDocument in friendDocuments.documents {
                let friendDocumentDictionary = friendDocument.data()
                guard let userReference = friendDocumentDictionary["user"] as? DocumentReference else {
                    completion(Result.failure(FriendsServiceError.emptyId))
                    return
                }
                userReference.getDocument(completion: { dictionaryData, error in
                    guard let userDictionary = dictionaryData?.data() else {return}
                    let user = User(user: userDictionary)
                    guard let friend = user else {return}
                    users.append(friend)
                })
            }
            completion(Result.success(users))
        }
    }

    func getRequests(
        completion: @escaping (FriendsResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        
        friendsCollection
            .whereField("receiver", isEqualTo: currentUserID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { collectionDocuments, error in
                
            guard let collectionDocuments = collectionDocuments else {
                completion(Result.failure(FriendsServiceError.emptyId))
                return
            }
                let users = collectionDocuments.documents.compactMap({ docs in
                    docs.data().flatMap({ data in return User(user: data)})
                })
                
                users.isEmpty ? completion(.success([])) : completion(.success(users))
        }
    }

    func getSent(
        completion: @escaping (FriendsResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        
        friendsCollection
            .whereField("sender", isEqualTo: currentUserID)
            .whereField("status", isEqualTo: "pending")
            .getDocuments { collectionDocuments, error in
                
                guard let collectionDocuments = collectionDocuments else {
                    completion(Result.failure(FriendsServiceError.emptyId))
                    return
                }
                let users = collectionDocuments.documents.compactMap({ docs in
                    docs.data().flatMap({ data in return User(user: data)})
                })
                
                users.isEmpty ? completion(.success([])) : completion(.success(users))
        }
    }
    
    func approveRequest(
        completion: @escaping (RequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        
    }
    
    func declineRequest(
        completion: @escaping (RequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
    }
    
    func sentRequest(
        completion: @escaping (RequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
    }
}


