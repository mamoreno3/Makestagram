//
//  LikeService.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/28/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase

class LikeService {
    static func create(for post: Post, success: @escaping (Bool) -> Void) {
        // get the current post
        guard let key = post.key else {
            return success(false)
        }
        
        // get the current user uid
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                
                return success(false)
            }
            // increment the like count in posts branch
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                }
                success(true)
            })
        }
    }
    
    static func delete(for post: Post, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        let currentUID = User.current.uid
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData = currentCount - 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: {(error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                }
                success(true)
            })
        }
    }
}
