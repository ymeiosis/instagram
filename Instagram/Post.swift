//
//  Post.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import Foundation

class Post {
    var postID : String = ""
    var posterID : String = ""
    var likes : [String] = []
    var timeStamp : Int = 0
    var postedPicUrl : String = ""
    var caption : String = ""
    
    init(postID: String, dict : [String : Any]){
        self.postID = postID
        self.posterID = dict["posterID"] as? String ?? "No poster ID"
        self.likes = dict["likes"] as? [String] ?? []
        self.timeStamp = dict["timeStamp"] as? Int ?? 0
        self.postedPicUrl = dict["postedPicUrl"] as? String ?? "No postedPicUrl"
        self.caption = dict["caption"] as? String ?? "No caption"
    }
    
    
    
}
