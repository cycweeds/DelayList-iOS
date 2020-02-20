//
//  AppConstants.swift
//  DelayList
//
//  Created by cyc on 2/17/20.
//  Copyright © 2020 weeds. All rights reserved.
//


public enum AppBuildChannel: String {
    /// 发布
    case release
    /// 测试
    case debug
}


public struct AppConstants {
    
    /// UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    public static let cellSeparatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    /// UIEdgeInsets(top: 0, left: 1000000, bottom: 0, right: 0) 把cell 移除当前屏幕
    public static let cellNotShowSeparatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 1000000, bottom: 0, right: 0)
    
    public static let BuildChannel: AppBuildChannel = {
        #if DEBUG
            return AppBuildChannel.debug
        #else
            return AppBuildChannel.release
        #endif
    }()
    
    public static func isDebug() -> Bool {
        return AppConstants.BuildChannel == .debug
    }

    public static func isRelease() -> Bool {
        return AppConstants.BuildChannel == .release
    }
}
