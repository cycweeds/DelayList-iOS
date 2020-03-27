//
//  DLUserSettingHeader.swift
//  DelayList
//
//  Created by cyc on 3/20/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLUserSettingHeader: UIView {
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        updateUser()
    }
    
    func updateUser() {
        guard let user = DLUserManager.shared.currentUser else { return }
        avatarImageView.kf.setImage(with: URL(string: user.avatar))
        userNameTF.text = user.name
    }
    
}


