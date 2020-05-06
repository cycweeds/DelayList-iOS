//
//  DLTaskImortantListViewController.swift
//  DelayList
//
//  Created by cyc on 3/7/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskImortantListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    
        tableView.cwl.cancelSelfSizing()
        
        
        // register
        tableView.cwl.registerNibCell(class: DLTaskCell.self)
        tableView.cwl.registerHeadFooterView(class: DLTaskCompletedDivisionHeaderView.self)
        return tableView
    }()
    
    
    var groupTasks: [(TaskGroup, [Task])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dl_red_503939
        title = "重要"
        
        view.addSubview(tableView)
               tableView.snp.makeConstraints { (make) in
                   make.edges.equalToSuperview()
               }
        
        fetchDate()
    }
  
    func fetchDate() {
        RSSessionManager.rs_request(RSRequestTask.getAllImportant) { (result) in
            switch result {
            case .success(let response):
                self.groupTasks = response.data.arrayValue.map { (json) -> (TaskGroup, [Task]) in
                    let group = TaskGroup(json: json["group"])
                    let tasks = json["tasks"].arrayValue.map { Task(json: $0) }
                    return (group, tasks)
                }
                
                self.tableView.reloadData()
                
            default:
                break
            }
        }
    }
}

extension DLTaskImortantListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTasks[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cwl.dequeueResuableCell(class: DLTaskCell.self, indexPath: indexPath)
        let task = groupTasks[indexPath.section].1[indexPath.row]
        cell.update(task: task)
//        cell.completedButtonTapHandler = { [unowned self] in
//            self.changeComplete(task: task)
//        }
//        cell.changeImportantHandler = { [unowned self] important in
//            self.changeImportant(task: task, important: important)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let taskGroup = groupTasks[section].0
        let header = tableView.cwl.dequeueReusableHeaderFooterView(class: DLTaskCompletedDivisionHeaderView.self)
        header.button.setTitle(taskGroup.title, for: .normal)
        header.button.isEnabled = false
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = groupTasks[indexPath.section].1[indexPath.row]
        let vc = DLTaskDetailViewController(task: task)
        navigationController?.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    struct DeleteConfirm {
        static var isDelete = false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = groupTasks[indexPath.section].1[indexPath.row]
            let delete = UITableViewRowAction(style: .normal, title: "删除") { [unowned self] (action, indexPath) in
//                self.delete(task: task)
                   }
        delete.backgroundColor = UIColor.red
       
        return [delete]
    }
}
