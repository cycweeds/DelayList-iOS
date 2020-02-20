//
//  AppDelegate.swift
//  LazyList
//
//  Created by cyc on 2019/10/16.
//  Copyright © 2019 weeds. All rights reserved.
//

import UIKit

@_exported import CWLKit
@_exported import SwiftyJSON
@_exported import SnapKit
@_exported import Alamofire



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        addNotificationObserver()
        setupRootVC()
        
        
        
        
        return true
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: "receivedLoginSuccess", name: NSNotification.Name.User.LoginSuccess, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: "receivedLogout", name: NSNotification.Name.User.Logout, object: nil)
    }

    
    var isLogin: Bool {
        return DLUserManager.shared.isLogin
    }
    
    func setupRootVC() {
        if isLogin {
            window?.rootViewController = DLNavigationController(rootViewController: DLTaskGroupViewController())
        } else {
            window?.rootViewController = DLLoginViewController()
        }
    }
    
    
    @objc func receivedLogout() {
        
        setupRootVC()
    }
    
    @objc func receivedLoginSuccess() {
        
        setupRootVC()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

