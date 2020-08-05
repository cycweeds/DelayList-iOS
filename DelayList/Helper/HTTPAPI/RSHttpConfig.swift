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
        return "http://localhost:8090"
    case .release:
        return "http://mengtaotech.com:8090"
    }
}
