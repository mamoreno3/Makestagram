//
//  Post.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    var key: String?
    let imageUrl: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url": imageUrl,
                "image_height": imageHeight,
                "created_at": createdAgo]
    }
    
    init(imageUrl: String, imageHeight: CGFloat) {
        self.imageUrl = imageUrl
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    // init for posts based on the user info object
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
        let imageUrl = dict["image_url"] as? String,
        let imageHeight = dict["image_height"] as? CGFloat,
        let createdAgo = dict["created_at"] as? TimeInterval
        else {
            return nil
        }
        
        self.key = snapshot.key
        self.imageUrl = imageUrl
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
    }
}
