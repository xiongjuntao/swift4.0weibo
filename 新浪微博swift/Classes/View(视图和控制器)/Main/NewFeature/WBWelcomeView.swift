//
//  WBWelcomeView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/15.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import Kingfisher

class WBWelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomComs: NSLayoutConstraint!
    
    
    class func welcomeView() -> WBWelcomeView {
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        
        v.frame = UIScreen.main.bounds
        return v
        
    }
    
    
    override func awakeFromNib() {

        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large else{
                return
        }
        
        iconView.cz_setImage(urlString: urlString, placeholderImage: UIImage.init(named: "avatar_default_big"), isAvatar: true)
//        iconView.kf.setImage(with: ImageResource.init(downloadURL: url), placeholder:UIImage.init(named: "avatar_default_big") )
        
        iconView.layer.cornerRadius = 85 * 0.5
        iconView.layer.masksToBounds = true
        
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.layoutIfNeeded()
        
        bottomComs.constant = bounds.size.height - 200
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            // 更新约束
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 提示：initWithCode 只是刚刚从 XIB 的二进制文件将视图数据加载完成
        // 还没有和代码连线建立起关系，所以开发时，千万不要在这个方法中处理 UI
        print("initWithCoder + \(iconView)")
    }
    
    
    
    
}
