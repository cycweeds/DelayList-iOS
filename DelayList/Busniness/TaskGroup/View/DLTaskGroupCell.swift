//
//  DLTaskGroupCell.swift
//  DelayList
//
//  Created by cyc on 2/19/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLTaskGroupCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(taskGroup: TaskGroup) {
        nameLabel.text = taskGroup.title
        
        switch taskGroup.type {
        case .inbox:
            icon.image = UIImage(named: "inbox")
        case .today:
            icon.image = UIImage(named: "today")
        case .normal:
            icon.image = UIImage(named: "group")
        case .important:
            icon.image = UIImage(named: "important")
        }
        
        if taskGroup.count == 0 {
            countLabel.text = ""
        } else {
            countLabel.text = "\(taskGroup.count)"
        }
        
    }
    
}
