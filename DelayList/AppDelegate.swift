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
@_exported import Kingfisher



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        addNotificationObserver()
        
        setupAppearence()
        setupRootVC()
        
        
        configVendor(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        return true
    }
    
    func setupAppearence() {
        let tableView = UITableView.appearance()
        tableView.separatorColor = UIColor.dl_gray_F2F2F2
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
    
    func configVendor(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        JPUSHService.setup(withOption: launchOptions, appKey: "25a80b51697e0694d6655576", channel: "App Store", apsForProduction: AppConstants.isDebug())
      


        DLUploaderManager.shared

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
        JPUSHService.setBadge(0)
    }
    

}



extension AppDelegate: JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        
         if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
         }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
               
        if response.notification.request.trigger is UNPushNotificationTrigger {
                   JPUSHService.handleRemoteNotification(userInfo)
                }
               completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
}
