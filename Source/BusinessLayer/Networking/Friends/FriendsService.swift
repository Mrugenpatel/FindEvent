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
        static let friendRequests = "friend_requests"
        static let receiver = "receiver"
        static let sender = "sender"
        static let status = "status"
    }

    private let friendsCollection = Firestore.firestore().collection(CollectionKeys.friendRequests)

    private let usersService: UserService

    init(usersService: UserService) {
        self.usersService = usersService
    }

    func getFriends(completion: @escaping (FriendsResult) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}

        friendsCollection.document(currentUserID).getDocument { document, error in
            guard let data = document?.data() else {return}
            let user = User(user: data)


        }

    }

//    func getFriends(completion: @escaping (FriendsResult) -> Void) {
//        guard let currendUserID = Auth.auth().currentUser?.uid else {return}
//
//        var friends = [User]()
//
//        friendsCollection
//            .whereField(CollectionKeys.receiver, isEqualTo: currendUserID)
//            .whereField(CollectionKeys.status, isEqualTo: "accepted")
//            .getDocuments { (snapshot, error) in
//                guard error == nil else { return }
//                guard let documents = snapshot?.documents else {return}
//                for document in documents {
//                    if let document = FriendRequest(friendRequest: document.data()) {
//                        guard let id = document.receiver else {return}
//                        self.usersService.getById(userId: id, completion: { responseResult in
//                            switch responseResult {
//                            case .success(let friend):
//                                friends.append(friend)
//                            case .failure(_):
//                                completion(Result.failure(FriendsServiceError.emptyId)); return
//                            }})}}}
//
//        friendsCollection
//            .whereField(CollectionKeys.sender, isEqualTo: currendUserID)
//            .whereField(CollectionKeys.status, isEqualTo: "accepted")
//            .getDocuments { (snapshot, error) in
//                guard error == nil else { return }
//                guard let documents = snapshot?.documents else {return}
//                for document in documents {
//                    if let document = FriendRequest(friendRequest: document.data()) {
//                        guard let id = document.sender else {return}
//                        self.usersService.getById(userId: id, completion: { responseResult in
//                            switch responseResult {
//                            case .success(let friend):
//                                friends.append(friend)
//                            case .failure(_):
//                                completion(Result.failure(FriendsServiceError.emptyId)); return
//                            }})}
// completion(Result.success(friends))
//                }
//
//        }
//    }

}

//        friendsCollection
//            .whereField(CollectionKeys.sender, isEqualTo: currendUserID)
//            .whereField(CollectionKeys.status, isEqualTo: "accepted")
//            .getDocuments { (snapshot, error) in
//            guard error == nil else { return }
//            guard let documents = snapshot?.documents else {return}
//            for document in documents {
//                if let document = FriendRequest(friendRequest: document.data()) {
//                    friendsRequests.append(document)}}
//        }

/*
 fetchFriends

 fetchRequests

 fetchSent

 approveRequest

 declineRequest

 sentRequest

 */

