//
//  WBOAuthViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/13.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        
        view.backgroundColor = UIColor.white
        title = "登录新浪微博"
        webView.scrollView.isScrollEnabled = false
        // 设置代理
        webView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFill))
    }
    
    @objc private func close () {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        
        let js = "document.getElementById('userId').value = ''; " +
        "document.getElementById('passwd').value = '';"
        
        webView.stringByEvaluatingJavaScript(from: js)
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURL)"
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)

    }
}


extension WBOAuthViewController: UIWebViewDelegate {
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        if request.url?.absoluteString.hasPrefix(WBRedirectURL) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        let start = (request.url?.query)!
        
        let code = start[5..<start.count]
//        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码 - \(code)")
        
        WBNetworkManager.shared.loadAccessToken(code: code){ (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                SVProgressHUD.showInfo(withStatus: "登录成功")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
                self.close()
            }
        }
        
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}




