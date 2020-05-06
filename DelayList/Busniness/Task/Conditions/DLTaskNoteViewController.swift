//
//  DLTaskNoteViewController.swift
//  DelayList
//
//  Created by cyc on 4/15/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskNoteViewController: UIViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 20, right: 12)
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.backgroundColor = .clear
        return textView
    }()
    
    var noteChangedHandler: ((String) -> ())?
    
    lazy var rightItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "完成", style: .done, target: self, action: "rightItemTapped")
        return item
    }()
    
    var note: String = ""
    
    let noteColor = UIColor.dl_orange_E4E20A
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightItem
        title = "备注"
        textView.text = note
        view.backgroundColor = noteColor

        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = navigationController?.navigationBar as? DLPresentNavigationBar
        bar?.layer.backgroundColor = noteColor.cgColor
           
        if textView.text.isEmpty {        
            textView.becomeFirstResponder()
        }
    }
    
    @objc func rightItemTapped() {
        noteChangedHandler?(textView.text)
        dismiss(animated: true, completion: nil)
    }

}


extension DLTaskNoteViewController: CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect {
        return CGRect(x: 0, y: kScreenHeight / 4 , width: kScreenWidth, height: kScreenHeight / 4 * 3)
    }
}
