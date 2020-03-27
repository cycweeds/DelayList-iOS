//
//  DLTaskContactSettingViewController.swift
//  DelayList
//
//  Created by cyc on 2/27/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit
import ContactsUI

class DLTaskContactSettingViewController: UIViewController {
    
    lazy private var findContactButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("通讯录", for: .normal)
        btn.setTitleColor(UIColor.dl_blue_6CAAF2, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.addTarget(self, action: "findContact", for: .touchUpInside)
        return btn
    }()
    
    private var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.dl_gray_F2F2F2
        tf.cornerRadius = 8
        tf.placeholder = "联系人手机号"
        tf.cwl.addPaddingLeft(padding: 8)
        return tf
    }()
    
    
    var selectContactHandler: ((CNContact?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "联系人"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .done, target: self, action: "confirmButtonTapped")
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(45)
//            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                // Fallback on earlier versions
            }
        }
        
        view.addSubview(findContactButton)
        findContactButton.snp.makeConstraints { (make) in
            make.right.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
    }
    
    
    @objc func findContact() {
        let pickerVC = CNContactPickerViewController()
        
        pickerVC.delegate = self
        
        present(pickerVC, animated: true, completion: nil)
    }
    
    var contact: CNContact?
    
    @objc func confirmButtonTapped() {
        selectContactHandler?(contact)
        dismiss(animated: true, completion: nil)
    }
    
}

extension DLTaskContactSettingViewController: CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect {
        return CGRect(x: 0, y: kScreenHeight - 300 , width: kScreenWidth, height: 300)
    }
    
    
}


extension DLTaskContactSettingViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
//        dismiss(animated: true) {
//            let contactVC = CNContactViewController(for: contact)
//            contactVC.delegate = self
//            self.present(contactVC, animated: true, completion: nil)
//            
//        }
        
//
        self.contact = contact
        textField.text = contact.phoneNumbers.first?.value.stringValue
        
    }
}

extension DLTaskContactSettingViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
                textField.text = contact?.phoneNumbers.first?.value.stringValue
                selectContactHandler?(contact)
    }
}
