//
//  User.swift
//  Instagram
//
//  Created by Ban Er Win on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import Foundation


class User {
    
    var uid : String = ""
    var email : String = ""
    var name : String = ""
    var userName : String = ""
    var url : String = ""
    
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        self.email = dict["email"] as? String ?? "No Email"
        self.name = dict["name"] as? String ?? "No Name"
        self.userName = dict["userName"] as? String ?? "No Username"
        self.url = dict["url"] as? String ?? "No Url"
        
    }
    
    
}
