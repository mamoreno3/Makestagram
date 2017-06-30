//
//  FollowService.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService {
    // user is other users, User.current is the current usr who is logged in
    // 2 branches, followers and people who user is following
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)": true,
                          "following/\(currentUID)/\(user.uid)": true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        
        let unfollowData = ["followers/\(user.uid)/\(currentUID)": NSNull(),
                            "following/\(currentUID)/\(user.uid)": NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(unfollowData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            success(error == nil)
        }
    }
    
    // followee: the user is being followed
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let followRef = Database.database().reference().child("followers").child(user.uid)
        
        followRef.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? [String: Bool] {
                completion(true)
            } else {
                completion(false)
            }
        
        })
    }
}
