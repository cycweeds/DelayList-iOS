//
//  DLTaskTimeSelectViewController.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//


import Foundation
@_exported import UIKit

class DLTaskTimeSelectViewController: UIViewController {
    
    private var timeView: UIDatePicker = {
       let timeView = UIDatePicker()
        return timeView
    }()
    
    var dateMode: UIDatePicker.Mode = .dateAndTime
    
    var selectTimeHandler: ((Date?) -> ())?
    
    var setDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        timeView.datePickerMode = dateMode
        
        if let setDate = setDate {
            timeView.date = setDate
            let deleteItem = UIBarButtonItem(title: "删除", style: .done, target: self, action: #selector(leftItemTapped))
            deleteItem.tintColor = UIColor.dl_red_B02424
            navigationItem.leftBarButtonItem = deleteItem
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(rightItemTapped))
        
        view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    @objc func rightItemTapped() {
        selectTimeHandler?(timeView.date)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func leftItemTapped() {
        selectTimeHandler?(nil)
        dismiss(animated: true, completion: nil)
    }
}

extension DLTaskTimeSelectViewController: CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect {
        return CGRect(x: 0, y: kScreenHeight - 400 , width: kScreenWidth, height: 400)
    }
}
