//
//  DLTaskExpireDateCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskContactCell: DLTaskBaseCell {
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        imageView?.image = UIImage(named: "contact")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContact(_ phone: String?) {
        if let phone = phone {
            textLabel?.text = phone
            textLabel?.textColor = UIColor.dl_blue_6CAAF2
            cancelButton.isHidden = false
        } else {
            textLabel?.text = "联系人"
            cancelButton.isHidden = true
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
        }
        
    }
}
