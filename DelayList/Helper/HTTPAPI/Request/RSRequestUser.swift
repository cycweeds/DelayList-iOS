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
    
    
    var url: String {
        switch self {
        case .getVerificationCode:
            return kHttpBaseURL + "/user/getVerificationCode"
        case .login:
            return kHttpBaseURL + "/user/login"
            
            
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getVerificationCode(let phone):
            return ["phone": phone]
        case .login(let verificationCode, let phone):
            return ["verificationCode": verificationCode, "phone": phone]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVerificationCode:
            return .get
        default:
            return .post
        }
    }
    
    
}
