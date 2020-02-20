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
    case update(params: [String: Any])
    case changeCompleted(taskId: Int, isComplete: Bool)
    case delete(taskId: Int)
    case moveToGroup(groupID: Int)
    case get(groupId: Int?)
    
    
    var url: String {
        let taskBaseURL = kHttpBaseURL + "/task"
        switch self {
        case .add:
            return taskBaseURL + "/add"
        case .update:
            return taskBaseURL + "/update"
        case .delete:
            return taskBaseURL + "/delete"
        case .moveToGroup:
            return taskBaseURL + "/move"
        case .get:
            return taskBaseURL + "/get"
        case .changeCompleted:
            return taskBaseURL + "/completed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .delete:
            return .delete
        default:
            return .post
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
        case .update(let params):
            return params
        case .delete(let taskId):
            return ["taskId": taskId]
        case .moveToGroup(let groupID):
            return ["groupID": groupID]
        case .changeCompleted(let taskId, let isComplete):
            return ["isComplete": isComplete, "taskId": taskId]
        }
    }
    
}
