//
//  DLWebViewController.swift
//  DelayList
//
//  Created by cyc on 2020/7/30.
//  Copyright © 2020 weeds. All rights reserved.
//

import UIKit
import WebKit



class WebViewController: UIViewController {

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController

       let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()
    
    var progressView = WebProgressView()
    
    lazy var userContentController: WKUserContentController = WKUserContentController ()
    
    
    /// 暂时这个值是一定存在的
    private var url: URL?
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.url?.absoluteString ?? "")
        
        if self.url == nil {
            fatalError("You must use init(url: URL).")
        }
        extendedLayoutIncludesOpaqueBars = true
        
        setupUI()
        
        
        let request = URLRequest(url: url!)
        webView.load(request)
        
        

        if let backItem = self.navigationItem.leftBarButtonItem {
            backItem.action = #selector(WebViewController.back)
            backItem.target = self
        }
    }
    
    @objc private func back() {
        if webView.canGoBack {
            webView.goBack()
            
        } else {
            if let nav = self.navigationController {
                if nav.topViewController == self {
                    dismiss(animated: true, completion: nil)
                } else {
                    nav.popViewController(animated: true)
                }
                
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: [.initial, .new], context: nil)
        
        progressView.addObserver(self, forKeyPath: #keyPath(WebProgressView.progress), options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
   
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        progressView.removeObserver(self, forKeyPath: #keyPath(WebProgressView.progress))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        if let title = change?[.newKey] as? String, keyPath == #keyPath(WKWebView.title) {
            self.title = title
        }
        
        if let progress = change?[.newKey] as? CGFloat, keyPath == #keyPath(WKWebView.estimatedProgress) {
            
                self.progressView.setProgress(progress, animated: true)
        }
        
        if let progress = change?[.newKey] as? CGFloat, keyPath == #keyPath(WebProgressView.progress) {
            if progress == 1 {
                self.progressView.isHidden = true
            } else {
                self.progressView.isHidden = false
            }
        }
    }
    
    deinit {
        
    }
    
    // MARK: - Actions
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(3)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let redirectURL = webView.url {
            if redirectURL.scheme?.hasPrefix("http") ?? false {
                return
            }
            if UIApplication.shared.canOpenURL(redirectURL) {
                var title = ""
                if redirectURL.absoluteString.contains("//itunes.apple.com/") {
                    title = "即将前往AppStore"
                } else if redirectURL.absoluteString.hasPrefix("http") {
                    //
                    title = "即将前往Safari"
                } else {
                    title = "即将离开当前app"
                }
                let alertVC = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
                alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
                alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.destructive, handler: { _ in
                     UIApplication.shared.open(redirectURL, options: [:], completionHandler: nil)
                }))
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let fredential = URLCredential(trust: serverTrust)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, fredential)
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        self.webView.isNetworkError = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        self.webView.isNetworkError = true
//        self.webView.networkErrorView?.titLabel.text = error.localizedDescription
//        self.webView.networkErrorView?.reloadHandler = { [unowned self] in
//            self.webView.isNetworkError = false
//            // 这里会存在失败的情况 暂时直接加载原来的信息
//            if webView.url != nil {
//                self.webView.reload()
//            } else {
//                self.webView.load(URLRequest(url: self.url!))
//            }
//        }
        print("webView didFailProvisionalNavigation \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail \(error.localizedDescription)")
        
//        self.webView.isNetworkError = true
        //        self.webView.networkErrorView?.titLabel.text = error.localizedDescription
//        self.webView.networkErrorView?.reloadHandler = { [unowned self] in
//            self.webView.isNetworkError = false
//            if webView.url != nil {
//                self.webView.reload()
//            } else {
//                self.webView.load(URLRequest(url: self.url!))
//            }
//        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        
        
    }
    
    
}

// MARK: WKUIDelegate
extension WebViewController: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let confirmVC = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        confirmVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action) in
            completionHandler(false)
        }))
        confirmVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            completionHandler(true)
        }))
        present(confirmVC, animated: true, completion: nil)
    }
    
    // js中alert方法捕捉
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
        completionHandler()
    }
    
}


// MARK: WKScriptMessageHandler
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
}
