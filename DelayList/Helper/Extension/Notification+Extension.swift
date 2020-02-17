//
//  Notification+Extension.swift
//  DelayList
//
//  Created by cyc on 2020/1/2.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation


extension Notification.Name {
    struct User {
        static var LoginSuccess = Notification.Name.init("User.LoginSuccess")
        
        static var Logout = Notification.Name.init("User.Logout")
        
    }
}
