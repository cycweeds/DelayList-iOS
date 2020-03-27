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
    
    var currentUser: User? {
        didSet {
            if currentUser != nil {
                JPUSHService.setAlias("\(currentUser!.id)", completion: nil, seq: 0)
                
                NotificationCenter.default.post(name: NSNotification.Name.User.Update, object: nil)
            } else {
                JPUSHService.deleteAlias(nil, seq: 0)
            }
        }
    }
    
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
        currentUser = nil
        token = nil
        
        NotificationCenter.default.post(name: NSNotification.Name.User.Logout, object: nil)
    }
    
    
    func updateCurrentUser(params: [String: Any], completed: (() -> ())?) {
        RSSessionManager.rs_request(RSRequestUser.updateUser(pararms: params)) { (result) in
            switch result {
            case .success(let response):
                self.currentUser = User(json: response.data)
                
                completed?()
            default: break
            }
        }
    }
}
