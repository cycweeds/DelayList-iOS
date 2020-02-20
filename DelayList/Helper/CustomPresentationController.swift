//
//  CustomPresentationController.swift
//  Tag
//
//  Created by cyc on 2018/12/7.
//  Copyright © 2018 CYC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum PresentationBackgroundStyle {
    /// 黑色透明
    case black
    /// 毛玻璃效果
    case blurEffect
}


protocol CustomerPresentProtocol {
    var frameOfViewInContainerView: CGRect { get }
}

class CustomPresentationController: UIPresentationController {
    var backgroundStyle: PresentationBackgroundStyle = .black
    var canDismiss = true
    
    
    lazy private var dismissGesture: UITapGestureRecognizer = {
       let dismissGesture = UITapGestureRecognizer(target: self, action: "close")
        if !canDismiss {
            dismissGesture.isEnabled = false
        }
        return dismissGesture
    }()
    
    
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    @objc private func close() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)

    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        if let presentProtocol = presentedViewController as? CustomerPresentProtocol {
            return presentProtocol.frameOfViewInContainerView
        }
        return super.frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else {
            return
        }
      
        if presentingViewController.transitionCoordinator == nil {
            return
        }
        // 手势需要加在 presentedView 上面
        // iOS响应链  上层视图会优先响应
        
        switch backgroundStyle {
        case .black:
            containerView.addSubview(backgroundView)
            backgroundView.addGestureRecognizer(dismissGesture)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            backgroundView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 1
            }
        case .blurEffect:
            presentedView?.addGestureRecognizer(dismissGesture)
            // 下面两种设置都是一样的 在这边UIVisualEffectView的效果没用
            // UIVisualEffectView 官方介绍 alpha 没用 尽量别用这个
            //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(frame: backgroundView.bounds)
            blurEffectView.frame = backgroundView.bounds
            backgroundView.addSubview(blurEffectView)
            
            backgroundView.frame = containerView.frame
            containerView.addSubview(backgroundView)
            backgroundView.addGestureRecognizer(dismissGesture)
            
        
            UIView.animate(withDuration: 0.25) {
                blurEffectView.effect = blurEffect
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.backgroundView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
                //                    print("done dismiss animation")
            })
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let container = self.containerView {
            self.backgroundView.frame = container.frame
        }
    }
}


// MARK: - Delegate
extension CustomPresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
}
