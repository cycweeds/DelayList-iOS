//
//  File.swift
//  DelayList
//
//  Created by cyc on 2020/7/30.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation

/// 支持渐变的进度条
class WebProgressView: UIView {
    
    
    @objc dynamic var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var link: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    convenience init() {
        self.init(frame: .zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // 目标进度
    private var goalProgress: CGFloat = 0
    
    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        if animated {
            goalProgress = progress
            if link == nil {
                link = CADisplayLink(target: self, selector: #selector(WebProgressView.refresh))
                link?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            }
        } else {
            self.progress = progress
        }
    }
    
    @objc private func refresh() {
        let currentProgress = progress + 0.03
        if currentProgress > goalProgress {
            progress = goalProgress
            link?.remove(from: .current, forMode: .common)
            link?.invalidate()
            link = nil
        } else {
            progress = currentProgress
        }
    }
    
    /// 可以设置渐变色
    var colors: CFArray = [UIColor.dl_blue_6CAAF2.cgColor, UIColor.dl_blue_6CAAF2.cgColor] as CFArray
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        guard let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil) else {
            return
        }
        if progress == 0.0 {
            return
        }
    
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width * progress, height: rect.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: rect.height / 2, height: rect.height / 2))
        context.addPath(path.cgPath)
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: rect.height / 2), end: CGPoint(x: rect.width * progress, y: rect.height / 2), options: .drawsBeforeStartLocation)
    }
}
