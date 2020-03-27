//
//  DLTaskListViewController.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskListViewController: UIViewController {
    
    var group: TaskGroup?
    
    var completeTasks: [Task] = []
    
    var unCompleteTasks: [Task] = []
    
    var showComplete = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = header
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    
        tableView.cwl.cancelSelfSizing()
        
        
        // register
        tableView.cwl.registerNibCell(class: DLTaskCell.self)
        tableView.cwl.registerHeadFooterView(class: DLTaskCompletedDivisionHeaderView.self)
        return tableView
    }()
    
    lazy var header: DLTaskAddHeaderView = {
        let header = DLTaskAddHeaderView.xibView()
        
        header.addTextField.delegate = self
        return header
    }()
    
    init(group: TaskGroup) {
        super.init(nibName: nil, bundle: nil)
        self.group = group
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.frame = CGRect(x: 0, y: 0, width: view.width, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.backgroundColor = UIColor.dl_red_503939
        title = group?.title ?? ""
        fetchData()
    }
    
    func changeComplete(task: Task) {
        task.isComplete = !task.isComplete
        tableView.reloadData()
        RSSessionManager.rs_request(RSRequestTask.changeCompleted(taskId: task.id, isComplete: task.isComplete)) { (result) in
            
        }
    }
    
    func delete(task: Task) {
        if task.isComplete {
            if let index = completeTasks.firstIndex(where: { (subTask) -> Bool in
                subTask === task
            }) {
                completeTasks.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
            }
        } else {
            if let index = unCompleteTasks.firstIndex(where: { (subTask) -> Bool in
                subTask === task
            }) {
                unCompleteTasks.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        
        
        RSSessionManager.rs_request(RSRequestTask.delete(taskId: task.id)) { (result) in
            
        }
    }
    
    func changeImportant(task: Task, important: Bool) {
        task.isImportant = important
        tableView.reloadData()
        
        RSSessionManager.rs_request(RSRequestTask.update(task: task)) { (result) in
            switch result {
            case .success(let response):
                break
            default:
                break
            }
        }
    }
    
    func addTask(name title: String) {
        if title.isEmpty { return }
        
        let task = Task()
        task.groupId = group?.id
        task.title = title
        unCompleteTasks.append(task)
        tableView.insertRows(at: [IndexPath(item: unCompleteTasks.count - 1, section: 0)], with: .automatic)
        var paramters: [String: Any] = ["title": title]
        if let groupId = group?.id {
                   paramters.updateValue(groupId, forKey: "groupId")
               }
        RSSessionManager.rs_request(RSRequestTask.add(params: paramters)) { (result) in
            switch result {
            case .success(let response):
                break
            default:
                break
            }
        }
    }


    func fetchData() {
        RSSessionManager.rs_request(RSRequestTask.get(groupId: group?.id)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                 response.data.arrayValue.forEach {
                  let task =  Task(json: $0)
                    if task.isComplete {
                        strongSelf.completeTasks.append(task)
                    } else {
                        strongSelf.unCompleteTasks.append(task)
                    }
                }
                strongSelf.tableView.reloadData()
            default:
                break
            }
        }
    }
    
}

extension DLTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking {
            header.addTextField.resignFirstResponder()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !showComplete && section == 1 {
            return 0
        }
        return section == 0 ? unCompleteTasks.count : completeTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cwl.dequeueResuableCell(class: DLTaskCell.self, indexPath: indexPath)
        let task = indexPath.section == 0 ? unCompleteTasks[indexPath.row] : completeTasks[indexPath.row]
        cell.update(task: task)
        cell.completedButtonTapHandler = { [unowned self] in
            self.changeComplete(task: task)
        }
        cell.changeImportantHandler = { [unowned self] important in
            self.changeImportant(task: task, important: important)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || completeTasks.isEmpty { return nil }
        let header = tableView.cwl.dequeueReusableHeaderFooterView(class: DLTaskCompletedDivisionHeaderView.self)
        header.showComplete = self.showComplete
        header.changeShowStatusHandler = { [unowned self] isShow in
            self.showComplete = isShow
            

            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || completeTasks.isEmpty { return 0.01 }
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = indexPath.section == 0 ? unCompleteTasks[indexPath.row] : completeTasks[indexPath.row]
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
        
        let task = indexPath.section == 0 ? unCompleteTasks[indexPath.row] : completeTasks[indexPath.row]
            let delete = UITableViewRowAction(style: .normal, title: "删除") { [unowned self] (action, indexPath) in
                self.delete(task: task)
                   }
        delete.backgroundColor = UIColor.red
       
        return [delete]
    }
}

extension DLTaskListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTask(name: textField.text ?? "")
        textField.text = nil
        return true
    }
}
