//
//  WBNavigationController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/5.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationBar.isHidden = true
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BACK_BUTTON")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popToParent))
            
//            viewController.na
//            if let vc = viewController as? WBBaseViewController {
//                var title = "返回"
//
//                if childViewControllers.count == 1 {
//                    title = childViewControllers.first?.title ?? "返回"
//                }
//                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target:self , action: #selector(popToParent))
//            }
        }
       
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func popToParent () {
        popViewController(animated: true)
    }

}

extension WBNavigationController {
    
    
}
