//
//  RSRequestUser.swift
//  Tag
//
//  Created by cyc on 2019/1/22.
//  Copyright © 2019 CYC. All rights reserved.

import Foundation
import Alamofire

enum RSRequestUser: RSHTTPRequestProtocol {
    /// 获取验证码
    case getVerificationCode(phone: String)
    /// 登录
    case login(verificationCode: String, phone: String)
    /// 获取当前用户
    case getCurrentUser
    /// 更新
    case updateUser(pararms: [String: Any])
    
    
    var url: String {
        let path: String
        switch self {
        case .getVerificationCode:
            path = "/user/getVerificationCode"
        case .login:
            path = "/user/login"
        case .updateUser:
            path = "/user/update"
        case .getCurrentUser:
            path = "/user/getCurrent"
        }
        return kHttpBaseURL + path
    }
    
    var parameters: Parameters? {
        switch self {
        case .getVerificationCode(let phone):
            return ["phone": phone]
        case .login(let verificationCode, let phone):
            return ["verificationCode": verificationCode, "phone": phone]
        case .updateUser(let pararms):
            return pararms
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateUser:
            return .patch
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    
}
