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
        requestID: String,
        completion: @escaping (RequestResult) -> Void
    )
    
    func declineRequest(
        requestID: String,
        completion: @escaping (RequestResult) -> Void
    )
    
    func sentRequest(
        requestUserID: String,
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
        friendsCollection
            .document(currentUserID)
            .collection("friends")
            .getDocuments { (documentsArray, error) in
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
        // go to document with current user and friend user
        // delete document in friendsCollection with friendUser and currentUser ids
        
    }
    
    func getRequests(
        completion: @escaping (FriendsRequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        
        friendsRequestsCollection
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
        
        friendsRequestsCollection
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
        requestID: String,
        completion: @escaping (RequestResult) -> Void
        ) {
        friendsRequestsCollection.document(requestID).setValue("accepted", forKey: "status")
        completion(.success(true))
        
    }
    
    func declineRequest(
        requestID: String,
        completion: @escaping (RequestResult) -> Void
        ) {
        friendsRequestsCollection.document(requestID).setValue("declined", forKey: "status")
        completion(.success(true))
    }
    
    func sentRequest(
        requestUserID: String,
        completion: @escaping (RequestResult) -> Void
        ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        friendsRequestsCollection
            .document(requestUserID+currentUserID)
            .setData(
                FriendRequest(
                    id: requestUserID+currentUserID,
                    receiver: requestUserID,
                    sender: currentUserID,
                    status: "pending").data())
            { error in
                guard error == nil else {
                    completion(.success(false));
                    return
                }
                completion(.success(true))
        }
    }
}


