//
//  HTTPRequestProtocol.swift
//  Tag
//
//  Created by cyc on 2018/12/4.
//  Copyright © 2018 CYC. All rights reserved.
//

import Foundation
import Alamofire


protocol RSHTTPRequestProtocol {
    // required
    var url: String { get }
    
    // optional
    var method: HTTPMethod { get }
    
    var parameters: Parameters? { get }
    
    var encoding: ParameterEncoding { get }
    
    var headers: HTTPHeaders? { get }
}

extension RSHTTPRequestProtocol {
    var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
