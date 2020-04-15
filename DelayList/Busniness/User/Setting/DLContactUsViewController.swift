//
//  DLContactUsViewController.swift
//  DelayList
//
//  Created by cyc on 4/7/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

import MessageUI

class DLContactUsViewController: UIViewController {


    let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "欢迎您联系我们，您可以反馈使用中遇到的bug，以及提出产品的意见。"
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var emailButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "email"), for: .normal)
        btn.addTarget(self, action: "emailTapped", for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "联系我们"
        
        view.backgroundColor = UIColor.dl_gray_F2F2F2
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(90)
        }

        view.addSubview(emailButton)
        emailButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(80)
            make.right.equalTo(messageLabel).offset(-30)
        }
    }
    
    @objc func emailTapped() {
        guard let name = DLUserManager.shared.currentUser?.name else {
            return
        }
       
        let email = "cycweeds@gmail.com"
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([email])
            mailVC.setSubject("来自用户\(name)的邮件")
            present(mailVC, animated: true, completion: nil)
            
        } else {
                   UIPasteboard.general.string = email
                   showAlert(message: "邮箱已复制")
        }
    }
    
}

extension DLContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        dismiss(animated: true, completion: nil)
    }
}
