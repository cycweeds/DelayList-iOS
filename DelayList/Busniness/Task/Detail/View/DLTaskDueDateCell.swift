//
//  DLTaskExpireDateCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskDueDateCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        textLabel?.text = "请设置到期时间"
        
        imageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        })
        
        
        textLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(55)
            make.centerY.equalToSuperview()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateDueDate(_ dueDate: Date?) {
        imageView?.image = UIImage(named: "dueTime")
        if let date = dueDate {
            
            textLabel?.textColor = UIColor.black
            if date.isToday {
                textLabel?.text = "今天"
                return
            }
            let formatter = DateFormatter()
            // 是否是今年
            if date.year == Date().year {
                formatter.dateFormat = "M-d"
                
            } else {
                formatter.dateFormat = "yyyy-MM-dd"
            }
            textLabel?.text = formatter.string(from: date)
            
        } else {
            textLabel?.text = "截止日期"
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
        }
    }
    
    
    func updateRemindDate(_ remindDate: Date?) {
        imageView?.image = UIImage(named: "remind")
        if let date = remindDate {
            let formatter = DateFormatter()
            // 是否是今年
            if date.year == Date().year {
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            textLabel?.text = formatter.string(from: date)
            textLabel?.textColor = UIColor.black
        } else {
            textLabel?.text = "提醒时间"
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
            
        }
    }
}
