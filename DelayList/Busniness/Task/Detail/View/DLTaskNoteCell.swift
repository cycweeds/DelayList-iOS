//
//  DLTaskNoteCell.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskNoteCell: UITableViewCell {
    
    lazy var textView: RSTextView = {
        let textView = RSTextView()
        textView.placeholder = "备注"
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.delegate = self
        return textView
    }()
    
    var textChangedHandler: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DLTaskNoteCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChangedHandler?(textView.text)
    }
}
