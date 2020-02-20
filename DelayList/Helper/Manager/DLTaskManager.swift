//
//  DLTaskManager.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskManager {
    let todayGroup: TaskGroup = {
        var group = TaskGroup()
        group.title = "今天"
        group.type = .today
        return group
    }()
    
    let inboxGroup: TaskGroup = {
         var inboxGroup = TaskGroup()
         inboxGroup.title = "暂存箱"
         inboxGroup.type = .inbox
        return inboxGroup
    }()
    
    static var shared: DLTaskManager = {
       let manger = DLTaskManager()
    
        return manger
    }()
    
    var taskGroups: [TaskGroup] = []
    
    var task: [Task] = []
    
    
    func fetchAll(completed: (() -> ())?) {
        RSSessionManager.rs_request(RSRequestTaskGroup.getAll) { (result) in
            switch result {
            case .success(let response):
                let groups = response.data.arrayValue.map {
                    return TaskGroup(json: $0)
                }
                self.taskGroups.append(contentsOf: groups)
                completed?()
                
            case .failure:
                fallthrough
            case .error:
                break
//                self.fetchAll(completed: completed)
                
            }
        }
    }
    
    func addTask(title: String, groupId: Int? = nil, completed: (() -> ())?) {
        
        var paramters: [String: Any] = ["title": title]
        if let groupId = groupId {
            paramters.updateValue(groupId, forKey: "groupId")
        }
        RSSessionManager.rs_request(RSRequestTask.add(params: paramters)) { (result) in
            switch result {
            case .success(let response):
                let task = Task(json: response.data)
                self.task.append(task)
                if groupId == nil {
                    self.inboxGroup.count += 1
                }
                NotificationCenter.default.post(name: NSNotification.Name.Task.TaskUpdate, object: nil, userInfo: ["task": task])
                completed?()
            default:
                break
                
            }
        }
    }
    
    
    func addTaskGroup(title: String, completed: (() -> ())?) {
        RSSessionManager.rs_request(RSRequestTaskGroup.add(title: title)) { (result) in
            switch result {
            case .success(let response):
                let group = TaskGroup(json: response.data)
                self.taskGroups.append(group)
                completed?()
                
            default:
                break
                
            }
        }
    }
    
}
