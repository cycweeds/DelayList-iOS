//
//  DLTaskDetailViewController.swift
//  DelayList
//
//  Created by cyc on 2/20/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskDetailViewController: UIViewController {
    
    var task: Task
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // register
        tableView.cwl.registerNibCell(class: DLTaskCell.self)
        tableView.cwl.registerCell(class: DLTaskNoteCell.self)
        tableView.cwl.registerCell(class: DLTaskDueDateCell.self)
        tableView.cwl.registerCell(class: DLTaskContactCell.self)
        tableView.cwl.registerCell(class: DLTaskRemindRepeatCell.self)
        
        return tableView
    }()
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "移动", style: .plain, target: self, action: "moveToOther")
    }
    
    @objc func moveToOther() {
        let alertVC = UIAlertController(title: "选择移动至", message: nil, preferredStyle: .actionSheet)
        for group in DLTaskManager.shared.taskGroups {
            if task.groupId != group.id {
                let action = UIAlertAction(title: group.title, style: .default) { _ in
                    if let groupId = group.id {
                        RSSessionManager.rs_request(RSRequestTask.moveToGroup(taskId: self.task.id,groupId: groupId)) { (result) in
                            switch result {
                            case .success(let response):
                                break
                            default:
                                break
                            }
                        }
                    }
                   
                    
                    
                }
                alertVC.addAction(action)
            }
        }
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension DLTaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate enum TableSection: Int {
        case title
        case dueDate
        case remindDate
        case remindFrequency
        case contact
        case note
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TableSection(rawValue: section) == TableSection.remindFrequency {
            if task.dueDate == nil {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = TableSection(rawValue: indexPath.section)
        switch tableSection {
        case .title:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskCell.self, indexPath: indexPath)
            cell.update(task: task)
            cell.changeImportantHandler = { [unowned self] important in
                
            }
            
//            cell.completedButtonTapHandler = {
//                
//            }
            return cell
        case .dueDate:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskDueDateCell.self, indexPath: indexPath)
            cell.updateDueDate(task.dueDate)
            return cell
        case .remindDate:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskDueDateCell.self, indexPath: indexPath)
            
            cell.updateRemindDate(task.remindDate)
            return cell
        case .remindFrequency:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskRemindRepeatCell.self, indexPath: indexPath)
            cell.updateFrequency(task.remindFrequency)
            return cell
        case .note:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskNoteCell.self, indexPath: indexPath)
            cell.textView.text = (task.note ?? "")
            cell.textChangedHandler = { [unowned self] str in
                self.task.note = str
            }
            return cell
        case .contact:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskContactCell.self, indexPath: indexPath)
            cell.updateContact(task.contactPhone)
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.section) {
        case .note:
            return 120
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section) {
        case .dueDate:
            let timeSelectVC = DLTaskTimeSelectViewController()
            timeSelectVC.dateMode = .date
            timeSelectVC.setDate = task.dueDate
            timeSelectVC.title = "截止日期"
            timeSelectVC.selectTimeHandler = { dueDate in
                self.task.dueDate = dueDate
                
                self.tableView.reloadData()
                DLTaskManager.shared.updateTask(task: self.task)
            }
            customerPresent(DLPresentNavigationViewController(rootViewController: timeSelectVC))
        case .remindDate:
            let timeSelectVC = DLTaskTimeSelectViewController()
            timeSelectVC.setDate = task.remindDate
            timeSelectVC.title = "提醒时间"
            timeSelectVC.selectTimeHandler = { dueDate in
                self.task.remindDate = dueDate
                self.tableView.reloadData()
                DLTaskManager.shared.updateTask(task: self.task)
            }
            customerPresent(DLPresentNavigationViewController(rootViewController: timeSelectVC))
        case .remindFrequency:
            let alertVC = UIAlertController(title: "提醒频率", message: nil, preferredStyle: .actionSheet)
            let frequencies: [TaskRemindFrequency] = [.day, .week, .workday, .month, .year]
            for frequency in frequencies {
                let alertAction = UIAlertAction(title: frequency.rawValue, style: .default) { _ in
                    self.task.remindFrequency = frequency
                    self.tableView.reloadData()
                }
             alertVC.addAction(alertAction)
            }
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            
        case .contact:
            let vc = DLTaskContactSettingViewController()
            vc.selectContactHandler = { contact in
                if let phone = contact?.phoneNumbers.first?.value.stringValue {
                    self.task.contactPhone = phone
                    DLTaskManager.shared.updateTask(task: self.task)
                    self.tableView.reloadData()
                }
               
            }
            customerPresent(DLPresentNavigationViewController(rootViewController: vc))
        default:
            break
        }
        
    }
}
