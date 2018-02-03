//
//  CZMeituanRefreshView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/20.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class CZMeituanRefreshView: UIView {
    
    @IBOutlet weak var buildingIconView: UIImageView!
    
    @IBOutlet weak var earthIconView: UIImageView!
    
    @IBOutlet weak var kangarooIconView: UIImageView!
    
    
    var parentViewHeight: CGFloat = 0 {
        didSet{
            if parentViewHeight < 23 {
                return
            }
            
            var scale: CGFloat
            if parentViewHeight > 126 {
                scale = 1
            }else{
                scale = 1 - ((126 - parentViewHeight) / (126 - 23))
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    var refreshState: CZRefreshState = .Normal

    override func awakeFromNib() {
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.5)
        
        let anim = CABasicAnimation.init(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthIconView.layer.add(anim, forKey: nil)
        
        let kImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        kangarooIconView.image = UIImage.animatedImage(with: [kImage1, kImage2], duration: 0.5)
        
        
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        kangarooIconView.center = CGPoint(x: x, y: y)
        
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
    }
    
    
    class func refreshView() -> CZMeituanRefreshView {
        
        let nib = UINib(nibName: "CZMeituanRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZMeituanRefreshView
        
    }
    
}
