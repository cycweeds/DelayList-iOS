//
//  DLUserSettingCell.swift
//  DelayList
//
//  Created by cyc on 3/20/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation



class DLUserSettingHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
    }
    
    lazy var once: Void = {
        textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        textLabel?.textColor = .dl_gray_d8d8d8
        textLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(12)
            make.center.equalToSuperview()
        })
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = once
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DLUserSettingLogoutCell: UITableViewCell {
    
    var logoutLable: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dl_red_B02424
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
