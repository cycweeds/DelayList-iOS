//
//  DLTaskAddViewController.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskAddViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet weak var finishedButton: UIButton!
    
    var groupId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishedButton.setTitleColor(UIColor.gray, for: .disabled)
        finishedButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    
    func addTask() {
        guard let title = textField.text else {
            return
        }
        
        DLTaskManager.shared.addTask(title: title, groupId: groupId, completed: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func finishedButtonTapped(_ sender: Any) {
        addTask()
    }
    
}

extension DLTaskAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.markedTextRange != nil {
            return true
        }
        addTask()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.markedTextRange != nil {
            return true
        }
        let replacedStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        finishedButton.isEnabled = !replacedStr.isEmpty
        return true
    }
}


extension DLTaskAddViewController: CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect {
        let height: CGFloat = 400
        return CGRect(x: 0, y: kScreenHeight - height, width: kScreenWidth, height: height)
    }
}
