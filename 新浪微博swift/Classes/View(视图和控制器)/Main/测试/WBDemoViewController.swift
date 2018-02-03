//
//  WBDemoViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/6.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(showNext))
    }
    
    
    @objc private func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


