//
//  Comment.swift
//  Instagram
//
//  Created by Philip Teow on 20/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import Foundation

class Comment {
    var commentID : String = ""
    var commentText : String = ""
    var timeStamp : Int = 0
    var userID : String = ""
    
    init() {
        
    }
    
    init(commentID : String, dict : [String : Any]) {
        self.commentID = commentID
        self.commentText = dict["commentText"] as? String ?? "No commentText in Class"
        self.timeStamp = dict["timeStamp"] as? Int ?? 0
        self.userID = dict["userID"] as? String ?? "No userID in Class"
    }
}
