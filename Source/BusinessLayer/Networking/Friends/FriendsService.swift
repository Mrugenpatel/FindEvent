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
    
    typealias FriendsRequestResult = (Result<([User],[FriendRequest]), FriendsServiceError>)
    typealias FriendsResult = (Result<[User], FriendsServiceError>)
    typealias RequestResult = (Result<Bool, FriendsServiceError>)
    
    func getFriends(
        completion: @escaping (FriendsResult) -> Void
    )
    
    func removeFriend(
        completion: @escaping (RequestResult) -> Void
    )
    
    func getSent(
        completion: @escaping (FriendsRequestResult) -> Void
    )
    
    func getRequests(
        completion: @escaping (FriendsRequestResult) -> Void
    )
    
    func approveRequest(
        completion: @escaping (RequestResult) -> Void // in document with id change status to "accepted"
    )
    
    func declineRequest(
        completion: @escaping (RequestResult) -> Void // in document with id change status to "declined"
    )
    
    func sentRequest(
        completion: @escaping (RequestResult) -> Void // in document with id change status to "pending"
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
    
    func removeFriend(
        completion: @escaping (RequestResult) -> Void
        ) {
        
    }

    func getRequests(
        completion: @escaping (FriendsRequestResult) -> Void
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
                let requests = collectionDocuments.documents.compactMap({ docs in
                    docs.data().flatMap({ data in return FriendRequest(friendRequest: data)})
                })
                
                if requests.isEmpty {
                    completion(.success(([],[])))
                    return
                }
                
                var users = [User]()
                
                for request in requests {
                    self.usersService.getById(userId: request.id!, completion: { responseResult in
                        switch responseResult {
                        case .success(let user):
                            users.append(user)
                        case .failure(_):
                            completion(Result.failure(FriendsServiceError.emptyId))
                            return
                        }
                    })
                }
                completion(.success((users,requests)))
        }
    }

    func getSent(
        completion: @escaping (FriendsRequestResult) -> Void
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
                let requests = collectionDocuments.documents.compactMap({ docs in
                    docs.data().flatMap({ data in return FriendRequest(friendRequest: data)})
                })
                
                if requests.isEmpty {
                    completion(.success(([],[])))
                    return
                }
                
                var users = [User]()
                
                for request in requests {
                    self.usersService.getById(userId: request.id!, completion: { responseResult in
                        switch responseResult {
                        case .success(let user):
                            users.append(user)
                        case .failure(_):
                            completion(Result.failure(FriendsServiceError.emptyId))
                            return
                        }
                    })
                }
                completion(.success((users,requests)))
        }
    }
    
    func approveRequest(
        completion: @escaping (RequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        
      //  fri
        
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


