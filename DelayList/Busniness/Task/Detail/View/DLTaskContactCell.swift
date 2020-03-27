//
//  DLTaskExpireDateCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskContactCell: UITableViewCell {
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        imageView?.image = UIImage(named: "inbox")
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContact(_ phone: String?) {
        if let phone = phone {
            textLabel?.text = phone
            textLabel?.textColor = UIColor.black
        } else {
            textLabel?.text = "联系人"
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
        }
        
    }
}
