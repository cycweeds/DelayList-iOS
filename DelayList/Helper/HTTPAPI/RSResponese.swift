//
//  RSResponese.swift
//  Tag
//
//  Created by cyc on 2018/12/4.
//  Copyright © 2018 CYC. All rights reserved.
//

import Foundation

struct RSResponse {
    var code: Int = 0
    var message: String = ""
    var data: JSON
    /// 业务是否成功
    var ok: Bool {
        return code >= 0
    }
    
    init(json: JSON) {
        code = json["code"].intValue
        message = json["message"].stringValue
        data = json["data"]
    }
}
