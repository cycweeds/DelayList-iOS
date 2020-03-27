//
//  RSTextView.swift
//  DelayList
//
//  Created by cyc on 2/25/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation



class RSTextView: UITextView {
    var maxLength: Int?
    
    var placeholder: String? {
        set {
            placeholderLabel.text = newValue
        }
        
        get {
            return placeholderLabel.text
        }
    }
    
    var placeholderColor: UIColor? {
        set {
            placeholderLabel.textColor = newValue
        }
        
        get {
            return placeholderLabel.textColor
        }
    }
    
    var placeholderFont: UIFont? {
        set {
            placeholderLabel.font = newValue
        }
        
        get {
            return placeholderLabel.font
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override var text: String! {
        didSet {
            refreshPlaceholder()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            refreshPlaceholder()
        }
    }
    
    lazy private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = self.font
        label.numberOfLines = 0
        label.textAlignment = self.textAlignment
        label.textColor = UIColor.lightGray
        addSubview(label)
        label.alpha = 1
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel.frame = placeholderExpectedFrame
        placeholderLabel.font = font
    }
    
    private var placeholderInsets : UIEdgeInsets {
        return UIEdgeInsets(top: self.textContainerInset.top, left: self.textContainerInset.left + self.textContainer.lineFragmentPadding, bottom: self.textContainerInset.bottom, right: self.textContainerInset.right + self.textContainer.lineFragmentPadding)
    }
    
    private var placeholderExpectedFrame : CGRect {
        let placeholderInsets = self.placeholderInsets
        let maxWidth = self.frame.width - placeholderInsets.left - placeholderInsets.right
        let expectedSize = placeholderLabel.sizeThatFits(CGSize(width: maxWidth, height: self.frame.height - placeholderInsets.top - placeholderInsets.bottom))
        
        return CGRect(x: placeholderInsets.left, y: placeholderInsets.top, width: maxWidth, height: expectedSize.height)
    }
    
    var observer: NSObjectProtocol?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        } else {
          observer = NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [unowned self] (notification) in
                guard let textView = (notification.object as? RSTextView) else {
                    return
                }
            
                if textView != self {
                    return
                }

                if self.markedTextRange != nil {
                    self.placeholderLabel.alpha = 0
                    return
                }

                if let maxLength = self.maxLength {
                    if self.text.count > maxLength {
                        self.text = String(self.text.prefix(maxLength))
                    }
                    
                    if self.attributedText.string.count > maxLength {
                      // 暂时不考虑
                    }
                }
                
                self.refreshPlaceholder()
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func refreshPlaceholder() {
        if !text.isEmpty || !attributedText.string.isEmpty {
            placeholderLabel.alpha = 0
        } else {
            placeholderLabel.alpha = 1
        }
    }
}
