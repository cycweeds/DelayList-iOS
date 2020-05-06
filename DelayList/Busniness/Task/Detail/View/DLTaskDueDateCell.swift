//
//  DLTaskExpireDateCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskDueDateCell: DLTaskBaseCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        textLabel?.text = "请设置到期时间"
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 更新截止日期
    func updateDueDate(_ dueDate: Date?) {
        imageView?.image = UIImage(named: "dueTime")
        if let date = dueDate {
            
            let now = Date()
            if date.isToday {
                textLabel?.text = "今天" + " 到期"
            } else {
                let formatter = DateFormatter()
                
                // 是否是今年
                if date.year == now.year {
                    formatter.dateFormat = "M月d日"
                    
                } else {
                    formatter.dateFormat = "yyyy年M月d日"
                }
                textLabel?.text = formatter.string(from: date) + " 到期"
            }
            
            
            if date.year >= now.year && date.month >= now.month && date.day >= now.day {
                // 未到期
                textLabel?.textColor = UIColor.dl_blue_6CAAF2
            } else {
                textLabel?.textColor = UIColor.dl_red_B02424
            }
            cancelButton.isHidden = false
        } else {
            textLabel?.text = "截止日期"
            cancelButton.isHidden = true
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
        }
    }
    
    
    /// 更新提醒日期
    func updateRemindDate(_ remindDate: Date?) {
        imageView?.image = UIImage(named: "remind")
        if let date = remindDate {
            let formatter = DateFormatter()
            // 是否是今年
            let now = Date()
            if date.year == now.year {
                formatter.dateFormat = "M月d日 H:mm"
            } else {
                formatter.dateFormat = "yyyy年M月d日 H:mm"
            }
            
            textLabel?.text = formatter.string(from: date) + " 提醒"
            
            if date > now {
                         // 未到期
                         textLabel?.textColor = UIColor.dl_blue_6CAAF2
                     } else {
                         textLabel?.textColor = UIColor.dl_red_B02424
                     }
            
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
            textLabel?.text = "提醒时间"
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
            
        }
    }
}
