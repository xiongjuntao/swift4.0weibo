//
//  CZRefreshView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/20.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class CZRefreshView: UIView {
    
    //刷新状态
    var refreshState: CZRefreshState = .Normal {
        didSet{
            switch refreshState {
            case .Normal:
                tipIcon.isHidden = false
                indicator?.stopAnimating()
                tipLabel.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel.text = "放手就刷新..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + 0.001))
                }
            case .WillRefresh:
                tipLabel.text = "正在刷新中..."
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }
    
    var parentViewHeight: CGFloat = 0

    @IBOutlet weak var tipIcon: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    class func refreshView() -> CZRefreshView {
//        let nib = UINib(nibName: "CZRefreshView", bundle: nil)
        
        let nib = UINib(nibName: "CZHumanRefreshView", bundle: nil)
//        let nib = UINib(nibName: "CZMeituanRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZRefreshView
        
    }

}
