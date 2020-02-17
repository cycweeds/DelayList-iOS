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
    
    @IBOutlet weak var bottomTipLabel: UILabel!
    // 倒计时 60秒
    var countDownTimeSeconds = 10
    
    var countDownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        line1Height.constant = 1 / kScale
        line2Height.constant = 1 / kScale

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
        indicatiorView.resignFirstResponder()
        
    }
    
    @objc func startCountDown() {
        
        if countDownTimeSeconds == 0 {
            countDownTimeSeconds = 10
            verificationCodeButton.isEnabled = true
            countDownTimer?.invalidate()
            countDownTimer = nil
            return
        }
        verificationCodeButton.setTitle("\(countDownTimeSeconds)s", for: UIControl.State.disabled)
        countDownTimeSeconds -= 1
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        loginButton.isEnabled = false
        indicatiorView.startAnimating()
        DispatchQueue.main.cwl_delay(second: 2) {
            
                
            
                NotificationCenter.default.post(name: NSNotification.Name.User.LoginSuccess, object: nil)
                self.loginButton.isEnabled = true
                self.indicatiorView.stopAnimating()
            
        }
        
    }
    
    
    @IBAction func fetchVerificationCode() {
        verificationCodeButton.isEnabled = false

        
        if countDownTimer == nil {
            countDownTimer = Timer(timeInterval: 1, target: self, selector: "startCountDown", userInfo: nil, repeats: true)
            RunLoop.main.add(countDownTimer!, forMode: RunLoop.Mode.common)
            countDownTimer?.fire()
        }
        
    }
    
    
    func viewUserProtocol() {
        
    }
    
    func viewPrivacyAgreement() {
        
    }
    
    
}
