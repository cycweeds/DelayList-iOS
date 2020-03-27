//
//  TaskGroup.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

// 0 正常  1 今天  2 暂存
enum TaskGroupType: Int {
    case normal
    case today
    case inbox
    case important
}

class TaskGroup {
    var id: Int?
    var title = ""
    
    var count = 0
    
    
    private var _type = 0
    
    var type: TaskGroupType {
        set {
            _type = newValue.rawValue
        }
        get {
            return TaskGroupType(rawValue: _type) ?? .normal
        }
    }
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["id"].int
        title = json["title"].stringValue
    }
}
