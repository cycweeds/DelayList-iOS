//
//  User.swift
//  DelayList
//
//  Created by cyc on 2/17/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation


struct User {
    var name = ""
    var phone = ""
    var id: Int = 0
    var avatar = ""
    
    init() {
        
    }
    
    init(json: JSON) {
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        id = json["id"].intValue
        avatar = json["avatar"].stringValue
    }
}
