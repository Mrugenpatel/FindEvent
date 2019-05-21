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
        var friends = [User]()
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(Result.failure(FriendsServiceError.emptyId))
            return
        }
        friendsCollection.document(currentUserID).collection("friends").getDocuments { (documentsArray, error) in
            guard let friendDocuments = documentsArray else {return}
            if friendDocuments.documents.count == 0 {
                completion(Result.success([]))
            }
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
                    friends.append(friend)
                })
            }
            completion(Result.success(friends))
        }
    }

    func getRequests(
        completion: @escaping (FriendsResult) -> Void
        ) {
    }

        func getSent(
            completion: @escaping (FriendsResult) -> Void
            ) {
        }
}

/*
 fetchRequests [User]
 fetchSent  [User]
 approveRequest Bool
 declineRequest Bool
 sentRequest Bool

 */

