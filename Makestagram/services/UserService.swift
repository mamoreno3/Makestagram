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
}
