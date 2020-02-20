//
//  RSResult.swift
//  Tag
//
//  Created by cyc on 2019/1/10.
//  Copyright © 2019 CYC. All rights reserved.
//

import Foundation

enum RSResult<Value> {
    /// 业务成功
    case success(Value)
    /// 业务失败
    case failure(RSHttpError, Value)
    /// 网络错误
    case error(RSHttpError)
    
    /// 业务成功才算成功
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .error:
            return false
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure(_, let value):
            return value
        default:
            return nil
        }
    }
    
    public var error: RSHttpError? {
        switch self {
        case .success:
            return nil
        case .failure(let error, _):
            return error
        case .error(let error):
            return error
        }
    }
}
