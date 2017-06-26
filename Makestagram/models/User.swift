//
//  User.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation

import FirebaseDatabase.FIRDataSnapshot

class User {
    // store user uid and username
    let uid: String
    let username: String
    
    init (uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    // check if the user is in the database or not
    // if not, return nil
    init? (snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"] as? String

        else {
            return nil
        }

        self.uid = snapshot.key
        self.username = username
        
    }
    
    // singleton for users
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error, user does not exist")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: User) {
        _current = user
    }
}
