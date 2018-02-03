//
//  WBWebViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/25.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {
    
    private lazy var webView = UIWebView.init(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet{
            guard let urlString = urlString,
            let url = URL.init(string: urlString) else {
                return
            }
            
            webView.loadRequest(URLRequest.init(url: url))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func setupTableView() {
        navigationItem.title = "网页"
        view.addSubview(webView)
        webView.backgroundColor = UIColor.white
//        webView.scrollView.contentInset.top = -64
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
