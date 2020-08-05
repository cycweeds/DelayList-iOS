//
//  DLLoginViewController.swift
//  DelayList
//
//  Created by cyc on 2020/1/2.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit

class DLLoginViewController: UIViewController {

    @IBOutlet weak var line1Height: NSLayoutConstraint!
    @IBOutlet weak var line2Height: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var verificationCodeButton: UIButton!
    
    @IBOutlet weak var verificationCodeInputTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    
    // 用下面的代替
    @IBOutlet weak var bottomTipLabel: UILabel!
    
    lazy var bottomLabel: YYLabel = {
        let label = YYLabel()
        
        let message = "登录即表示您已阅读并同意《用户协议》、《隐私政策》"
//        label.textColor = UIColor.dl_gray_BBBBBB
        
        let userRange = (message as NSString).range(of: "用户协议")
        let privacyRange = (message as NSString).range(of: "隐私政策")
        let attStr = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.dl_gray_BBBBBB])
        
        
        
        
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
    
    // 倒计时 60秒
    lazy private var currentCountDownTimeSeconds = countDownTimeSeconds
    
    private let countDownTimeSeconds = 60
    
    private var countDownTimer: Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.center.equalTo(bottomTipLabel)
        }
        bottomTipLabel.isHidden = true
        
        line1Height.constant = 1 / kScale
        line2Height.constant = 1 / kScale
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
        indicatiorView.resignFirstResponder()
        
    }
    
    @objc func startCountDown() {
        
        if currentCountDownTimeSeconds == 0 {
            currentCountDownTimeSeconds = countDownTimeSeconds
            verificationCodeButton.isEnabled = true
            countDownTimer?.invalidate()
            countDownTimer = nil
            return
        }
        verificationCodeButton.setTitle("\(currentCountDownTimeSeconds)s", for: UIControl.State.disabled)
        currentCountDownTimeSeconds -= 1
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        
        guard let code = verificationCodeInputTextField.text else { return }
        guard let phone = phoneTextField.text else { return }
        if code.isEmpty || phone.isEmpty {
             return
        }
        
        loginButton.isEnabled = false
        indicatiorView.startAnimating()
        
        RSSessionManager.rs_request(RSRequestUser.login(verificationCode: code, phone: phone)) { (result) in
            self.loginButton.isEnabled = true
            self.indicatiorView.stopAnimating()
            switch result {
            case .success(let response):
                let token = response.data["token"].stringValue
                let user = User(json: response.data["user"])
                    
                DLUserManager.shared.currentUser = user
                DLUserManager.shared.token = token
                NotificationCenter.default.post(name: NSNotification.Name.User.LoginSuccess, object: nil)
                              
            default: break
                
            }
        }
    }
    
    
    @IBAction func fetchVerificationCode() {
        guard let phone = phoneTextField.text else { return }
        if phone.isEmpty { return }
        
        verificationCodeButton.isEnabled = false
        
        RSSessionManager.rs_request(RSRequestUser.getVerificationCode(phone: phone)) {  [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let code = response.data["code"].stringValue
                
                if AppConstants.isDebug() {
                    strongSelf.verificationCodeInputTextField.text = code
                }
                
                
                
                if strongSelf.countDownTimer == nil {
                           strongSelf.countDownTimer = Timer(timeInterval: 1, target: strongSelf, selector: "startCountDown", userInfo: nil, repeats: true)
                           RunLoop.main.add(strongSelf.countDownTimer!, forMode: RunLoop.Mode.common)
                           strongSelf.countDownTimer?.fire()
                       }
                
            default:
                
                strongSelf.verificationCodeButton.isEnabled = true
                
            }
        }

       
        
    }
    
    
    func viewUserProtocol() {
        let webVC = WebViewController(url: URL(string: DLWebUrl.userProlicy)!)
        let nav = DLNavigationController(rootViewController: webVC)
        present(nav, animated: true, completion: nil)
        
    }
    
    func viewPrivacyAgreement() {
        
        let webVC = WebViewController(url: URL(string: DLWebUrl.privatcy)!)
        let nav = DLNavigationController(rootViewController: webVC)
        present(nav, animated: true, completion: nil)
    }
    
    
}
