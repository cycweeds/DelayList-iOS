//
//  DLTaskNoteCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskNoteCell: UITableViewCell {
    
    lazy var remarkLabel: UILabel = {
        let remarkLabel = UILabel()
        remarkLabel.text = "备注"
        remarkLabel.font = UIFont.boldSystemFont(ofSize: 17)
        remarkLabel.textColor = UIColor.dl_gray_BBBBBB
        remarkLabel.numberOfLines = 0
        return remarkLabel
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(remarkLabel)
        
        remarkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(8)
            make.bottom.lessThanOrEqualTo(-8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(remark: String?) {
        if remark?.isEmpty ?? true {
            remarkLabel.text = "备注"
            remarkLabel.textColor = UIColor.dl_gray_BBBBBB
        } else {
            remarkLabel.text = remark
            remarkLabel.textColor = UIColor.black
        }
    }
    
}

