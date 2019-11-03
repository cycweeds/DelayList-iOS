//
//  DLTabbarViewController.swift
//  LazyList
//
//  Created by cyc on 2019/10/17.
//  Copyright © 2019 weeds. All rights reserved.
//

import UIKit

class DLTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let nav1 = DLNavigationController(rootViewController: DLCircleHomeViewController())
        nav1.tabBarItem.title = "TODO"
        let nav2 = DLNavigationController(rootViewController: DLCircleHomeViewController())
        nav2.tabBarItem.title = "分享"
        let nav3 = DLNavigationController(rootViewController: DLMeHomeViewController())
        nav3.tabBarItem.title = "我的"
        
        setViewControllers([nav1, nav2, nav3], animated: false)
        
    }
    

}
