//
//  UserService.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    // _ means you dont have to state the argument name while calling the function?
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        // create new username in the database
        let userAttrs = ["username": username]
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            // if the user doesnt exist, execute nil, else execute the current user
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        // retrieve the data from the image source in the database, return the posts from the given users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            // determine wheter the post has been liked by the user, return the posts array
            let posts: [Post] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let post = Post(snapshot: $0) else {
                            print("1")
                            return nil
                        }
                        
                        dispatchGroup.enter()
                        
                        LikeService.isPostLiked(post) { (isLiked) in
                            post.isLiked = isLiked
                            dispatchGroup.leave()
                        }
                        return post
                    }
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            // get the list of users aside from the current user
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter {
                        $0.uid != currentUser.uid
            }
            
            let dispatchGroup = DispatchGroup()
            users.forEach{ (user) in
                dispatchGroup.enter()
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
        let followerRef = Database.database().reference().child("followers").child(user.uid)
        
        followerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followerDict = snapshot.value as? [String : Bool] else {
                return completion([])
            }
            
            let followersKeys = Array(followerDict.keys)
            completion(followersKeys)
        })
    }
}
