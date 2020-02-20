//
//  RSRequestTaskGroup.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

enum RSRequestTaskGroup: RSHTTPRequestProtocol {
    case add(title: String)
    case update(title: String, groupId: Int)
    case delete(groupId: Int)
    case getAll
    
    
    var url: String {
        let taskBaseURL = kHttpBaseURL + "/taskGroup"
        switch self {
        case .add:
            return taskBaseURL + "/add"
        case .update:
            return taskBaseURL + "/update"
        case .delete:
            return taskBaseURL + "/delete"
        case .getAll:
            return taskBaseURL + "/getAll"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .add(let title):
            return ["title": title]
        case .update(let title, let groupId):
            return ["title": title, "groupId": groupId]
        case .delete(let groupId):
            return ["groupId": groupId]
        case .getAll:
            return nil
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .delete:
            return .delete
        case .update, .add:
            return .post
        default:
            return .get
        }
    }
}
