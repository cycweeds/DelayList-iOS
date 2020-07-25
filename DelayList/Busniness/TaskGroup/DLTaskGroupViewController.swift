//
//  DLTaskGroupViewController.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskGroupViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.cwl.cancelSelfSizing()
        tableView.separatorStyle = .none
        tableView.tableFooterView = addGroupFooter
        
        // register
        tableView.cwl.registerNibCell(class: DLTaskGroupCell.self)
        return tableView
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add"), for: .normal)
        btn.addTarget(self, action: #selector(addButtonTapped), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var addGroupFooter: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
        let label = UILabel()
        label.textColor = UIColor.dl_blue_6CAAF2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "新建列表"
        
        let imageView = UIImageView(image: UIImage(named: "add_small")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        imageView.tintColor = .dl_blue_6CAAF2
        
        footer.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        footer.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addGroup)))
        return footer
    }()
    
    lazy var groupNavigationBar: DLTaskGroupNavigationBar = {
        let bar = DLTaskGroupNavigationBar(frame: .zero)
        bar.userContentTapHandler = { [unowned self] in
            self.gotoUserSetting()
        }
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(groupNavigationBar)
        
        groupNavigationBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(topLayoutGuide.snp.bottom).offset(60)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(groupNavigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-40)
        }
        
        fetchData()
        
        NotificationCenter.default.addObserver(self, selector: "taskUpdate:", name: NSNotification.Name.Task.Update, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "userUpdated", name: NSNotification.Name.User.Update, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        groupNavigationBar.updateUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func gotoUserSetting() {
        let settingVC = DLUserSettingViewController()
         let nav = DLNavigationController(rootViewController: settingVC)
        present(nav, animated: true)
    }
    
    @objc func userUpdated() {
        groupNavigationBar.updateUserInfo()
    }
    
    
    @objc func taskUpdate(_ notification: Notification) {
        guard let task = notification.userInfo?["task"] as? Task else {
            return
        }
        if task.groupId == nil {
            let zeroIndexPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [zeroIndexPath], with: .none)
            tableView.selectRow(at: zeroIndexPath, animated: true, scrollPosition: .none)
            
            DispatchQueue.main.cwl.delay(second: 0.5) {
                self.tableView.deselectRow(at: zeroIndexPath, animated: true)
            }
        } else {
            tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func fetchData() {
        DLTaskManager.shared.fetchAll { [weak self]  in
            self?.tableView.reloadData()
        }
        
        
        
        RSSessionManager.rs_request(RSRequestUser.getCurrentUser) { (result) in
            switch result {
            case .success(let response):
                
                let user = User(json: response.data)
                DLUserManager.shared.currentUser = user
                self.groupNavigationBar.updateUserInfo()
            default: break
            }
        }
    }
    
    @objc func addGroup() {
        let alertVC = UIAlertController(title: "列表创建", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (tf) in
            
        }
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            guard let name = alertVC.textFields?.first?.text else { return }
            self.add(name: name)
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func add(name: String) {
        if name.isEmpty { return }
        DLTaskManager.shared.addTaskGroup(title: name) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {
        let taskAddVC = DLTaskAddViewController()
        customerPresent(taskAddVC)
    }
}

extension DLTaskGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getTask(indexPath: IndexPath) -> TaskGroup {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return DLTaskManager.shared.inboxGroup
//            case 1:
//                return DLTaskManager.shared.todayGroup
//
            default:
                return DLTaskManager.shared.importantGroup
            }
        }
        return DLTaskManager.shared.taskGroups[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return DLTaskManager.shared.taskGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cwl.dequeueResuableCell(class: DLTaskGroupCell.self, indexPath: indexPath)
        let group: TaskGroup = getTask(indexPath: indexPath)
        cell.update(taskGroup: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async {

            let group: TaskGroup = self.getTask(indexPath: indexPath)
            if indexPath.section == 0 && indexPath.row == 1 {
                let vc = DLTaskImortantListViewController()
                self.navigationController?.pushViewController(vc)
            } else {
                let vc = DLTaskListViewController(group: group)
                self.navigationController?.pushViewController(vc)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
        }
        var footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        if footer == nil {
            footer = UITableViewHeaderFooterView(reuseIdentifier: "footer")
            footer?.backgroundView = UIView()
            let line = UIView()
            line.backgroundColor = UIColor.dl_gray_d8d8d8
            footer?.contentView.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(1 / kScale)
                make.centerY.equalToSuperview()
            }
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            return 0.01
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let group: TaskGroup = getTask(indexPath: indexPath)
        
        DLTaskManager.shared.deleteGroup(group) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
}
