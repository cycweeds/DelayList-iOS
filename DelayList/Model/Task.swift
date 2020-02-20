//
//  Task.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class Task {
    var id: Int = 0
    var title = ""
    
    var groupId: Int?
    
    var note: String?
    
    var isImportant: Bool = false
    var isComplete = false
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        groupId = json["groupId"].int
        note = json["note"].string
        isComplete = json["complete"].boolValue
        isImportant = json["isImportant"].boolValue
        
    }
}
