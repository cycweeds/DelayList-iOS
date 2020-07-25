//
//  DLUploaderManager.swift
//  DelayList
//
//  Created by cyc on 3/26/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation
import AliyunOSSiOS

class DLUploaderManager {
    
    let endpoint = "oss-cn-hangzhou.aliyuncs.com"
    
    let bucket = "delay-list"
    
    lazy var client: OSSClient = {
        
        let url: String
        
        if AppConstants.isDebug() {
            url = "http://127.0.0.1:7080/aliyun/token"
        } else {
            url = "\(kHttpBaseURL.replacingOccurrences(of: "8081", with: "7080"))/aliyun/token"
        }
        let provider = OSSAuthCredentialProvider(authServerUrl: url){ (data) -> Data? in
            let str =  String(data: data, encoding: .utf8)
            return data
        }
        
        let configuration = OSSClientConfiguration()
        let client = OSSClient(endpoint: "https://" + endpoint, credentialProvider: provider, clientConfiguration: configuration)
        
        return client
        
    }()
    
    static let shared: DLUploaderManager = DLUploaderManager()
    
    init() {
         
    }
    
    func upload(data: Data, completed: ((String?) -> ())?) {
        let request = OSSPutObjectRequest()
        request.bucketName = bucket
        let key = "avatar/\(UUID().uuidString).jpeg"
        request.objectKey = key
        request.uploadingData = data
        let putTask = client.putObject(request)
        putTask.continue({ (task) -> Any? in
            if task.error == nil {
                let url = "https://" + self.bucket + "." + self.endpoint + "/" + key
                completed?(url)
            }
            completed?(nil)
            return nil
        })
     
    }
}
