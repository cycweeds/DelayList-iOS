//
//  DLAboutViewController.swift
//  DelayList
//
//  Created by cyc on 4/7/20.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLAboutViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // register
        tableView.cwl.registerCell(class: UITableViewCell.self)
        return tableView
    }()
    
    var logoView: UIImageView = {
        let logoView = UIImageView(image: UIImage(named: "DelayList"))
        return logoView
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version   1.0"
        return label
    }()
    
    var bottomLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dl_black_999999
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "《用户协议》和《隐私协议》"
        return label
    }()
    
    
    var bottomLabel2: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.dl_black_999999
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Copyright © 2020 MengTao. All rights reserved."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dl_gray_F2F2F2

        view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(30)
        }
        
        view.addSubview(bottomLabel1)
        view.addSubview(bottomLabel2)
     
        bottomLabel2.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        bottomLabel1.snp.makeConstraints { (make) in
                 make.centerX.equalToSuperview()
                 make.bottom.equalTo(bottomLabel2.snp.top).offset(-5)
             }
    }
    
}


extension DLAboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cwl.dequeueResuableCell(class: UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "版本"
        return cell
    }
    
}
