//
//  DLUtil.swift
//  DelayList
//
//  Created by cyc on 2/17/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


