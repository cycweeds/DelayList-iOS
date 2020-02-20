//
//  DLTaskCompletedDivisionHeaderView.swift
//  DelayList
//
//  Created by cyc on 2/20/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskCompletedDivisionHeaderView: UITableViewHeaderFooterView {

    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("隐藏已完成任务", for: .selected)
        btn.setTitle("显示已完成任务", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        btn.cornerRadius = 4
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    var showComplete: Bool = false {
        didSet {
            if showComplete {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    
    var changeShowStatusHandler: ((Bool) -> ())?
    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeShowStatusHandler?(sender.isSelected)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
           
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
