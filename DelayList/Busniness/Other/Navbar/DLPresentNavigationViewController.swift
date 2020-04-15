//
//  DLPresentNavigationViewController.swift
//  DelayList
//
//  Created by cyc on 3/11/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit


// present 是一个圆弧状的导航栏
class DLPresentNavigationViewController: UINavigationController {
    
   
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: DLPresentNavigationBar.self, toolbarClass: nil)
        pushViewController(rootViewController, animated: false)
        rootViewController.edgesForExtendedLayout = [.left, .right, .bottom]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.edgesForExtendedLayout = [.left, .right, .bottom]
    }
    
}

extension DLPresentNavigationViewController: CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect {
        if let present = topViewController as? CustomerPresentProtocol {
            return present.frameOfViewInContainerView
        }
        return UIScreen.main.bounds
    }
}




class DLPresentNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .default
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
    
    let shapeLayer = CAShapeLayer()
    
    lazy var once: Void = {
        
        let path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        shapeLayer.path = path.cgPath
        layer.backgroundColor = UIColor.white.cgColor
        layer.mask = shapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = once
              
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
