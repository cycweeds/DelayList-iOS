//
//  DLNavigationController.swift
//  LazyList
//
//  Created by cyc on 2019/10/17.
//  Copyright © 2019 weeds. All rights reserved.
//

import UIKit

extension UIViewController {
    var dlNavigationController: DLNavigationController {
        return DLNavigationController(rootViewController: self)
    }
}

class DLNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: DLNavigationBar.self, toolbarClass: nil)
        pushViewController(rootViewController, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentingViewController != nil {
            let closeItem = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(close))
            closeItem.tintColor = .white
            self.viewControllers.first?.navigationItem.leftBarButtonItem = closeItem
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack() {
        popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewController != topViewController {
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(goBack))
        } else {
            
        }
    }

    
}

extension DLNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class DLNavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .default
        isTranslucent = false
        tintColor = .white
        setBackgroundImage(UIImage.image(UIColor.dl_red_503939), for: .default)
               shadowImage = UIImage()
        
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
