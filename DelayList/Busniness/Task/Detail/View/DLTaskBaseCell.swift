//
//  DLTaskBaseCell.swift
//  DelayList
//
//  Created by cyc on 4/14/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskBaseCell: UITableViewCell {
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: "cancelButtonTapped", for: .touchUpInside)
        btn.expandHotPoint = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn.isHidden = true
        return btn
    }()
    
    
    var cancelTapeHandler: (() -> ())?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonTapped() {
        cancelTapeHandler?()
    }
}
