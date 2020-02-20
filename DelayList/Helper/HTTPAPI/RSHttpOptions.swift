//
//  RSHttpUIConfig.swift
//  Tag
//
//  Created by cyc on 2019/2/23.
//  Copyright © 2019 CYC. All rights reserved.
//

import Foundation


public struct RSHttpOptions : OptionSet {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    /// 当网络失败的时候toast
    public static let toastWhenNetworkError = RSHttpOptions(rawValue: 1 << 0)
    /// 当网络业务的时候toast
    public static let toastWhenBussinessFailed = RSHttpOptions(rawValue: 1 << 1)
    
    
}
