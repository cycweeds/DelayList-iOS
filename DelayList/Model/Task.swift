//
//  Task.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

enum TaskRemindFrequency: String {
    case day = "DAY"
    case week = "WEEK"
    case workday = "WORKDAY"
    case month = "MONTH"
    case year = "YEAR"
    
    
    var description: String {
        switch self {
        case .day:
            return "每天"
        case .week:
            return "每周"
        case .month:
            return "每月"
        case .workday:
            return "每工作日"
        case .year:
            return "每年"
        }
    }
}

class Task {
    var id: Int = 0
    var title = ""
    
    var groupId: Int?
    
    var dueDate: Date?
    var remindDate: Date?
    private var _remindFrequency: String?
    
    var remindFrequency: TaskRemindFrequency? {
        get {
            if let remindFrequency = _remindFrequency {
                return TaskRemindFrequency(rawValue: remindFrequency)
            }
            return nil
        }
        set {
            _remindFrequency = newValue?.rawValue
        }
    }
    
    var note: String = ""
    
    var contactPhone: String?
    
    var isImportant: Bool = false
    var isComplete = false
    
    init() {
        
    }
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        groupId = json["groupId"].int
        note = json["note"].stringValue
        isComplete = json["complete"].boolValue
        isImportant = json["isImportant"].boolValue
        contactPhone = json["contactPhone"].string
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateString = json["dueDate"].string {
            dueDate = dateFormatter.date(from: dateString)
        }
        if let remindDateString = json["remindDate"].string {
            remindDate = dateFormatter.date(from: remindDateString)
        }
        
        
    }
}
