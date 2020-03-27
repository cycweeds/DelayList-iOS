//
//  DLTaskGroupNavigationBar.swift
//  DelayList
//
//  Created by cyc on 3/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit




class DLTaskGroupNavigationBar: UIView {
    
    var avatar: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var userLabel: UILabel = {
        let btn = UILabel()
        btn.textColor = .white
        btn.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    lazy var actionView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "userContentTapped"))
        return view
    }()
    
    var userContentTapHandler: (() -> ())?
    
    @objc func userContentTapped() {
        userContentTapHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatar)
        avatar.cornerRadius = 20
        avatar.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.snp.bottom).offset(-30)
            make.width.height.equalTo(40)
        }
        
        addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.right).offset(8)
            make.centerY.equalTo(avatar)
        }
        
        addSubview(actionView)
        actionView.snp.makeConstraints { (make) in
            make.left.equalTo(avatar)
            make.right.equalTo(userLabel)
            make.top.bottom.equalToSuperview()
        }
        backgroundColor = UIColor.dl_red_503939
        
        updateUserInfo()
    }
    
    func updateUserInfo() {
        guard let user = DLUserManager.shared.currentUser else {
            return
        }
        userLabel.text = user.name
        avatar.kf.setImage(with: URL(string: user.avatar))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
