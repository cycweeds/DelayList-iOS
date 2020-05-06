//
//  RSHttpConfig.swift
//  Tag
//
//  Created by cyc on 2018/12/4.
//  Copyright © 2018 CYC. All rights reserved.
//

import Foundation

public var kHttpBaseURL: String {
    
    switch AppConstants.BuildChannel {
    case .debug:
        return "http://192.168.1.34:8080"
    case .release:
        return "https://delaylist.cn"
    }
}

public var kHttpFileURL: String {
    
    switch AppConstants.BuildChannel {
    case .debug:
        return "http://tag-test.oss-cn-shanghai.aliyuncs.com/"
    case .release:
        return "https://file.tagapp.cn/"
    }
}

public var kHttpWebURL: String {
    switch AppConstants.BuildChannel {
    case .debug:
        return "http://tag-dev-1254361839.cos-website.ap-shanghai.myqcloud.com"
    case .release:
        return "https://h5.tagapp.cn"
    }
}
