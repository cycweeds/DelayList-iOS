//
//  DLTaskAddHeaderView.swift
//  DelayList
//
//  Created by cyc on 2/20/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskAddHeaderView: UIView {
    
    static func xibView() -> DLTaskAddHeaderView {
        return Bundle.main.loadNibNamed("DLTaskAddHeaderView", owner: nil, options: nil)?.first as! DLTaskAddHeaderView
    }
    
    
    @IBOutlet weak var addTextField: UITextField! {
        didSet {
            addTextField.attributedPlaceholder = NSAttributedString(string: "添加计划", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
     
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: kScreenWidth, height: 60)
    }
    

}
