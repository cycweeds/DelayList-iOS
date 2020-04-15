//
//  RSRequestTask.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

enum RSRequestTask: RSHTTPRequestProtocol {
    case add(params: [String: Any])
    case update(task: Task)
    case changeCompleted(taskId: Int, isComplete: Bool)
    case delete(taskId: Int)
    case moveToGroup(taskId: Int, groupId: Int)
    case get(groupId: Int?)
    case getAllImportant
    
    var url: String {
        let taskBaseURL = kHttpBaseURL + "/task"
        switch self {
        case .add:
            return taskBaseURL + "/add"
        case .update(let task):
            return taskBaseURL + "/update/\(task.id)"
        case .delete:
            return taskBaseURL + "/delete"
        case .moveToGroup:
            return taskBaseURL + "/move"
        case .get:
            return taskBaseURL + "/get"
        case .changeCompleted:
            return taskBaseURL + "/completed"
        case .getAllImportant:
            return taskBaseURL + "/getAllImportant"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get, .getAllImportant:
            return .get
        case .delete:
            return .delete
        case .update:
            return .put
        case .add:
            return .post;
        case .changeCompleted:
            return .patch
        case .moveToGroup:
            return .patch
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .get(let groupId):
            if let groupId = groupId, groupId != 0 {
                return ["groupId": groupId]
            } else {
                return nil
            }
            
        case .add(let params):
            return params
        case .update(let task):
            
            var params: [String: Any] = ["important": task.isImportant, "title": task.title, "complete": task.isComplete]
            params.updateValue(task.note, forKey: "note")
            
            if let dueDateTimestamp = task.dueDate?.timeIntervalSince1970 {
                params.updateValue(Int(dueDateTimestamp) * 1000, forKey: "dueDateTimestamp")
            }
            
            if let remindDateTimestamp = task.remindDate?.timeIntervalSince1970 {
                params.updateValue(Int(remindDateTimestamp) * 1000, forKey: "remindDateTimestamp")
            }
            
            if let contactPhone = task.contactPhone {
                params.updateValue(contactPhone, forKey: "contactPhone")
            }
            
            
            
            return params
        case .delete(let taskId):
            return ["taskId": taskId]
        case .moveToGroup(let taskId, let groupId):
            return ["groupId": groupId, "taskId": taskId]
        case .changeCompleted(let taskId, let isComplete):
            return ["isComplete": isComplete, "taskId": taskId]
            
        default:
            return nil
        }
    }
    
}
