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
    
    fileprivate enum TableSection: Int {
        case title
        case dueDate
        case remindDate
        case remindFrequency
        case note
        // 暂时移除联系人
        case contact
        
        static let count = 5
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // register
        tableView.cwl.registerNibCell(class: DLTaskCell.self)
        tableView.cwl.registerCell(class: DLTaskDueDateCell.self)
        tableView.cwl.registerCell(class: DLTaskContactCell.self)
        tableView.cwl.registerCell(class: DLTaskRemindRepeatCell.self)
        tableView.cwl.registerCell(class: DLTaskNoteCell.self)
        
        return tableView
    }()
    
    weak var textField: UITextField?
    
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
    
    func changeImportant(important: Bool) {
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
    
    
    
    func changeComplete() {
        task.isComplete = !task.isComplete
        tableView.reloadData()
        RSSessionManager.rs_request(RSRequestTask.changeCompleted(taskId: task.id, isComplete: task.isComplete)) { (result) in
            
        }
    }
    
    @objc func moveToOther() {
        let alertVC = UIAlertController(title: "选择移动至", message: nil, preferredStyle: .actionSheet)
        for group in DLTaskManager.shared.taskGroups {
            if task.groupId != group.id {
                let action = UIAlertAction(title: group.title, style: .default) { _ in
                    if let groupId = group.id {
                        RSSessionManager.rs_request(RSRequestTask.moveToGroup(taskId: self.task.id, groupId: groupId)) { [weak self] (result) in
                            switch result {
                            case .success(let response):
                                self?.task.groupId = groupId
                                NotificationCenter.default.post(name: NSNotification.Name.Task.Update, object: nil)
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
    
    private func updateTaskTitle() {
        guard let title = textField?.text else {
            return
        }
        if title == self.task.title {
            return
        }
        
        textField?.resignFirstResponder()
        self.task.title = textField?.text ?? ""
        DLTaskManager.shared.updateTask(task: self.task)
        self.tableView.reloadData()
    }
}

extension DLTaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.count
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
            self.textField = cell.textField
            cell.update(task: task)
            cell.isUseByDetail = true
            cell.textField.delegate = self
            cell.changeImportantHandler = { [unowned self] important in
                self.changeImportant(important: important)
            }
            
            cell.completedButtonTapHandler = { [unowned self] in
                self.changeComplete()
            }
            return cell
        case .dueDate:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskDueDateCell.self, indexPath: indexPath)
            cell.updateDueDate(task.dueDate)
            cell.cancelTapeHandler = { [unowned self] in
                self.task.dueDate = nil
                self.task.remindFrequency = nil
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: TableSection.remindFrequency.rawValue)], with: .automatic)
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: TableSection.dueDate.rawValue)], with: .automatic)
                self.tableView.endUpdates()
                DLTaskManager.shared.updateTask(task: self.task)
            }
            return cell
        case .remindDate:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskDueDateCell.self, indexPath: indexPath)
            cell.updateRemindDate(task.remindDate)
            cell.cancelTapeHandler = { [unowned self] in
                self.task.remindDate = nil
                DLTaskManager.shared.updateTask(task: self.task)
                self.tableView.reloadData()
            }
            return cell
        case .remindFrequency:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskRemindRepeatCell.self, indexPath: indexPath)
            cell.updateFrequency(task.remindFrequency)
            cell.cancelTapeHandler = { [unowned self] in
                self.task.remindFrequency = nil
                DLTaskManager.shared.updateTask(task: self.task)
                self.tableView.reloadData()
            }
            return cell
        case .note:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskNoteCell.self, indexPath: indexPath)
            cell.update(remark: task.note)
            return cell
        case .contact:
            let cell = tableView.cwl.dequeueResuableCell(class: DLTaskContactCell.self, indexPath: indexPath)
            cell.updateContact(task.contactPhone)
            cell.cancelTapeHandler = { [unowned self] in
                self.task.contactPhone = nil
                DLTaskManager.shared.updateTask(task: self.task)
                self.tableView.reloadData()
            }
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
        
        updateTaskTitle()
        
        DispatchQueue.main.async {
            switch TableSection(rawValue: indexPath.section) {
            case .dueDate:
                let timeSelectVC = DLTaskTimeSelectViewController()
                timeSelectVC.dateMode = .date
                timeSelectVC.setDate = self.task.dueDate
                timeSelectVC.title = "截止日期"
                timeSelectVC.selectTimeHandler = { dueDate in
                    
                    var isAnimated = false
                    if self.task.dueDate == nil && dueDate != nil {
                        isAnimated = true
                    }
                    self.task.dueDate = dueDate
                    
                    
                    self.tableView.beginUpdates()
                    if isAnimated {
                        self.tableView.insertRows(at: [IndexPath(row: 0, section: TableSection.remindFrequency.rawValue)], with: .automatic)
                    }
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: TableSection.dueDate.rawValue)], with: .automatic)
                    self.tableView.endUpdates()
                    
                    
                    DLTaskManager.shared.updateTask(task: self.task)
                }
                self.customerPresent(DLPresentNavigationViewController(rootViewController: timeSelectVC))
            case .remindDate:
                let timeSelectVC = DLTaskTimeSelectViewController()
                timeSelectVC.setDate = self.task.remindDate
                timeSelectVC.title = "提醒时间"
                timeSelectVC.selectTimeHandler = { dueDate in
                    if let dueDate = dueDate {
                        // 去掉秒
                        self.task.remindDate = Date(timeIntervalSince1970: TimeInterval(Int(dueDate.timeIntervalSince1970 / 60) * 60))
                    } else {
                        self.task.remindDate = nil
                    }
                    
                    
                    self.tableView.reloadData()
                    DLTaskManager.shared.updateTask(task: self.task)
                }
                self.customerPresent(DLPresentNavigationViewController(rootViewController: timeSelectVC))
            case .remindFrequency:
                let alertVC = UIAlertController(title: "提醒频率", message: nil, preferredStyle: .actionSheet)
                let frequencies: [TaskRemindFrequency] = [.day, .week, .month, .year]
                for frequency in frequencies {
                    let alertAction = UIAlertAction(title: frequency.description, style: .default) { _ in
                        self.task.remindFrequency = frequency
                        self.tableView.reloadData()
                    }
                    alertVC.addAction(alertAction)
                }
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                
            case .contact:
                let vc = DLTaskContactSettingViewController()
                vc.selectContactHandler = { contact in
                    if let phone = contact?.phoneNumbers.first?.value.stringValue {
                        self.task.contactPhone = phone
                        DLTaskManager.shared.updateTask(task: self.task)
                        self.tableView.reloadData()
                    }
                    
                }
                self.customerPresent(DLPresentNavigationViewController(rootViewController: vc))
                
            case .note:
                let vc = DLTaskNoteViewController()
                vc.note = self.task.note
                vc.noteChangedHandler = { note in
                    self.task.note = note
                    DLTaskManager.shared.updateTask(task: self.task)
                    self.tableView.reloadData()
                }
                self.customerPresent(DLPresentNavigationViewController(rootViewController: vc))
            default:
                break
            }
        }
        
    }
}

extension DLTaskDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.markedTextRange != nil {
            return true
        }
        
        updateTaskTitle()
        
        return true
    }
}
