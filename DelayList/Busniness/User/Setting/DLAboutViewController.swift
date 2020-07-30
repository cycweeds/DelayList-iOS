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
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                label.text = "Version  \(version)"
        }
        
        return label
    }()
    
     lazy var bottomLabel1: YYLabel = {
            let label = YYLabel()
            
            let message = "《用户协议》和《隐私政策》"
    //        label.textColor = UIColor.dl_gray_BBBBBB
            
            let userRange = (message as NSString).range(of: "用户协议")
            let privacyRange = (message as NSString).range(of: "隐私政策")
            let attStr = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.dl_black_999999])
            
            
            
            
            attStr.yy_setTextHighlight(userRange, color: UIColor.dl_blue_6CAAF2, backgroundColor: nil, userInfo: nil, tapAction: { [unowned self]  (view, str, range, rect) in
                self.viewUserProtocol()
                
            }, longPressAction: nil)
            
    //
            attStr.yy_setTextHighlight(privacyRange, color: UIColor.dl_blue_6CAAF2, backgroundColor: nil, userInfo: nil, tapAction: { [unowned self] (view, str, range, rect) in
                self.viewPrivacyAgreement()
                
            }, longPressAction: nil)
            label.attributedText = attStr
            
            
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
    
    
    func viewUserProtocol() {
        let webVC = WebViewController(url: URL(string: DLWebUrl.userProlicy)!)
        navigationController?.pushViewController(webVC)
        
    }
    
    func viewPrivacyAgreement() {
        
        let webVC = WebViewController(url: URL(string: DLWebUrl.privateProlicy)!)
        navigationController?.pushViewController(webVC)
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
