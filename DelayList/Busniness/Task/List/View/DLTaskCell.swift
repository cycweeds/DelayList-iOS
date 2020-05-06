//
//  DLTaskCell.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskCell: UITableViewCell {
    @IBOutlet weak var completedButton: UIButton! {
        didSet {
            completedButton.expandHotPoint = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            completedButton.addTarget(self, action: #selector(completedButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var unimportantButton: UIButton! {
        didSet {
            unimportantButton.addTarget(self, action: #selector(unimportantButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var importantButton: UIButton! {
        didSet {
            importantButton.addTarget(self, action: #selector(importantButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    var completedButtonTapHandler: (() -> ())?
    
    var changeImportantHandler: ((Bool) -> ())?
    
    @objc func completedButtonTapped() {
        completedButtonTapHandler?()
    }
    
    @objc func importantButtonTapped() {
           changeImportantHandler?(false)
       }
    
    @objc func unimportantButtonTapped() {
        changeImportantHandler?(true)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.white
        isUseByDetail = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let xSpace: CGFloat = 8.0
        let ySpace: CGFloat = 5.0
        contentView.frame = CGRect(x: xSpace, y: ySpace, width: contentView.frame.width - 2 * xSpace, height: contentView.frame.height - 2 * ySpace)
        contentView.cornerRadius = 4
        
    }
   
    
    var isUseByDetail: Bool = false {
        didSet {
            if isUseByDetail {
                textField.isEnabled = true
                textField.font = UIFont.boldSystemFont(ofSize: 18)
            } else {
                textField.isEnabled = false
                textField.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    func update(task: Task) {
        if task.isComplete {
            completedButton.isSelected = true
            textField.attributedText = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue), NSAttributedString.Key.foregroundColor: UIColor.dl_gray_d8d8d8])
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        } else {
            contentView.backgroundColor = .white
            completedButton.isSelected = false
            textField.attributedText = NSAttributedString(string: task.title)
        }
        
        importantButton.isHidden = true
        unimportantButton.isHidden = true
        if task.isImportant {
            importantButton.isHidden = false
        } else {
            unimportantButton.isHidden = false
        }
        
    }
    
}
