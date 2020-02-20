//
//  DLNavigationController.swift
//  LazyList
//
//  Created by cyc on 2019/10/17.
//  Copyright © 2019 weeds. All rights reserved.
//

import UIKit

class DLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

}

extension DLNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
