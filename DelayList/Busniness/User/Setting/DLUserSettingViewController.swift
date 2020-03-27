//
//  DLUserSettingViewController.swift
//  DelayList
//
//  Created by cyc on 3/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit
import PhotosUI
import WXImageCompress

class DLUserSettingViewController: UIViewController {
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.dl_gray_F2F2F2
        
        tableView.tableHeaderView = header
        header.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 250)
        // register
        
        tableView.cwl.registerCell(class: UITableViewCell.self)
        tableView.cwl.registerHeadFooterView(class: DLUserSettingHeaderView.self)
        return tableView
    }()
    
    lazy var header: DLUserSettingHeader = {
        let header = Bundle.main.loadNibNamed("DLUserSettingHeader", owner: nil, options: nil)?.first as! DLUserSettingHeader
        header.userNameTF.delegate = self
        header.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "avatarTapped"))
        
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped"))
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        
        
    }
    
    @objc func avatarTapped() {
        let photoVC = UIImagePickerController()
        photoVC.allowsEditing = true
        photoVC.delegate = self
        present(photoVC, animated: true, completion: nil)
    }
    
    @objc func viewTapped() {
        header.userNameTF.resignFirstResponder()
    }
    
}

extension DLUserSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        if let data = editedImage.wxCompress().pngData() {
            DLUploaderManager.shared.upload(data: data) { [weak self] url in
                if let url = url {
                    DLUserManager.shared.updateCurrentUser(params: ["avatar": url]) {
                        self?.header.updateUser()
                    }
                }
               
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension DLUserSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.userNameTF.resignFirstResponder()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cwl.dequeueResuableCell(class: UITableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cell.textLabel?.textColor = .black
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "高级"
            } else {
                cell.textLabel?.text = "登出"
                cell.textLabel?.textColor = .dl_red_B02424
            }
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "关于"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "评价"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "联系我们"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.cwl.dequeueReusableHeaderFooterView(class: DLUserSettingHeaderView.self)
        if section == 0 {
            header.textLabel?.text = "账户"
        } else {
            header.textLabel?.text = "其他"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                DLUserManager.shared.logout()
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                // 评价
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id1455435248?action=write-review") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
        }
    }
}


extension DLUserSettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if DLUserManager.shared.currentUser?.name != textField.text {
            
            
            DLUserManager.shared.updateCurrentUser(params: ["name": textField.text ?? ""]) { [weak self] in
                self?.header.updateUser()
            }
            
            
        }
    }
}
