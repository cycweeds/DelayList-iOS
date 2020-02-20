//
//  RSHttpError.swift
//  Tag
//
//  Created by cyc on 2019/1/10.
//  Copyright © 2019 CYC. All rights reserved.
//

import Foundation


/// 业务Error 值和后台返回的值保持一致
enum RSHttpError: Int, Error {
    // 默认有一个 -999999
    case none = -999999
    /// 网络错误
    case networkError = -999998
    /// 请求超时
    case requestTimeout = -1001
    case serverError = 500
  
}

extension RSHttpError : CustomStringConvertible {
    var description: String {
        return localizedDescription
    }
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "网络错误！"
        case .serverError:
            return "服务器异常！"
        default:
            return ""
        }
    }
}
