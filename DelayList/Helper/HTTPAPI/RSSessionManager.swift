//
//  RSSessionManager.swift
//  Tag
//
//  Created by cyc on 2018/12/4.
//  Copyright © 2018 CYC. All rights reserved.
//

import Foundation
import Alamofire

class RSSessionManager: SessionManager {
    public static let share: RSSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let manager = RSSessionManager(configuration: configuration)
        // 要开启监听才行
        manager.networkManager?.startListening()
        return manager
    }()
    
    deinit {
        networkManager?.stopListening()
    }
    
    /// 网络监测
    let networkManager = NetworkReachabilityManager()
    
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - request: 遵守RSHTTPRequestProtocol的对象
    ///   - queue: 默认是主线程
    ///   - completed: 完成回调
    /// - Returns: DataRequest对象
    @discardableResult
    public static func rs_request(_ request: RSHTTPRequestProtocol, queue: DispatchQueue? = nil, options: RSHttpOptions = [], completed: ((_ result: RSResult<RSResponse>) -> ())?) -> DataRequest? {
        
           let status = RSSessionManager.share.networkManager?.networkReachabilityStatus
        // 网络不触达 直接返回
        if status == .notReachable {
            let error = RSHttpError.networkError
            completed?(RSResult.error(error))
            return nil
        }
        
        var header: [String: String]?
            
        if let token = DLUserManager.shared.token {
            header  = ["Authorization": "Bearer " + token]
        }
        
        let request = RSSessionManager.share.request(request.url, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: header).rs_response(queue: queue, completed: completed)
        request.rsHttpOptions = options
        
        return request
    }
    
}


private var rsHttpOptionsKey = ""
extension DataRequest {
    var rsHttpOptions: RSHttpOptions {
        set {
            objc_setAssociatedObject(self, &rsHttpOptionsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &rsHttpOptionsKey) as? RSHttpOptions ?? []
        }
    }
    
    
    /// 发送请求
    ///
    /// - Parameters:
    ///   - queue: 队列  默认是主队列
    ///   - completed: 返回一个result
    /// - Returns: self
    func rs_response(queue: DispatchQueue? = nil, completed: ((_ result: RSResult<RSResponse>) -> ())?) -> Self {
        
        responseJSON(queue: queue) { (response) in
            
//            if !AppConstants.isRelease() {
                print("==========================")
                print(response.customerDescription)
                print("==========================")
//            }
            
            
            if response.response?.statusCode == 500 {
                let error = AppConstants.isRelease() ? RSHttpError.serverError : RSHttpError.networkError 
                completed?(RSResult.error(error))
                return
            } else if response.response?.statusCode == 401 {
        
                DLUserManager.shared.token = nil
                let error = RSHttpError.networkError
                completed?(RSResult.error(error))
                return
            } else if (response.error as NSError?)?.code == NSURLErrorCancelled {
                // 用户自己取消当前网络   不toast 这里直接用response  不用response.response
                // response 自己就会返回   response.response需要通过服务器才能有数据
                let error = RSHttpError.networkError
                completed?(RSResult.error(error))
                return
            }
            
            if let error = response.error {
                print("网络请求失败 \(error.localizedDescription)")
                let error = RSHttpError.networkError
            
                completed?(RSResult.error(error))
                // 网络请求失败
                return
            }
            
            guard let jsonData = response.data else {
                completed?(RSResult.error(RSHttpError.none))
                return
            }
            
            let responseData = JSON(jsonData)
            let rsResponse = RSResponse(json: responseData)
            // 若业务成功 返回成功的response对象   业务失败  则返回一个RSHttpError 对象
            
            if response.request?.url?.absoluteString.contains(kHttpBaseURL) ?? false {
                
                if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: kHttpBaseURL)!) {
                    if let sessionCookie = cookies.first(where: { (cookie) -> Bool in          
                        return cookie.name == "SESSION"
                    }) {
                        
                        UserDefaults.standard.set(sessionCookie.value, forKey: "SESSION")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            if rsResponse.ok {
                completed?(RSResult.success(rsResponse))
            } else {
               
                completed?(RSResult.failure(RSHttpError(rawValue: rsResponse.code) ?? .none, rsResponse))
            }
        }
        
        return self
    }
}



extension DataResponse {
    public var customerDescription: String {
           let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
           let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
            let requestHeader = request?.allHTTPHeaderFields ?? nil
           let responseDescription = response.map { "\($0)" } ?? "nil"
           let responseBody = data.map { String(decoding: $0, as: UTF8.self) } ?? "None"

           return """
           [Request]: \n\(requestDescription)
           [Request Header]: \n\(requestHeader?.description ?? "")
           [Request Body]: \n\(requestBody)
           [Response]: \n\(responseDescription)
           [Response Body]: \n\(responseBody)
           [Result]: \(result)
           [Timeline]: \(timeline.debugDescription)
           """
       }
}
