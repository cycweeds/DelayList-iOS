//
//  DLTaskRemindCell.swift
//  DelayList
//
//  Created by cyc on 2/27/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

class DLTaskRemindRepeatCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        })
        
        
        textLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(55)
            make.centerY.equalToSuperview()
        })
        imageView?.image = UIImage(named: "repeat")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateFrequency(_ frequency: TaskRemindFrequency?) {
          if let frequency = frequency {
            textLabel?.text = frequency.description
            textLabel?.textColor = UIColor.black
                } else {
                      textLabel?.text = "重复"
            textLabel?.textColor = UIColor.dl_gray_BBBBBB
                  }
    }
}
