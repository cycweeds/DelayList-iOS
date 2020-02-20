//
//  DLUserManager.swift
//  DelayList
//
//  Created by cyc on 2/17/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation


class DLUserManager {
    static var shared: DLUserManager = DLUserManager()
    
    var token: String? {
        get {
            UserDefaults.standard.object(forKey: "UserToken") as? String
        }
        
        set {
            
            UserDefaults.standard.set(newValue ?? nil, forKey: "UserToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isLogin: Bool {
        return token != nil
    }
    

    
    
    func logout() {
        
    }
}
