//
//  CZEmoticonTipView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/29.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import pop

class CZEmoticonTipView: UIImageView {
    
    private lazy var tipButton = UIButton()
    
    private var preEmoticon: CZEmoticon?
    
    var emoticon: CZEmoticon? {
        didSet{
            
            if emoticon == preEmoticon {
                return
            }
            
            preEmoticon = emoticon
            tipButton.setTitle(emoticon?.emoji, for: .normal)
            tipButton.setImage(emoticon?.image, for: .normal)
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = 30
            anim.toValue = 8
            
            anim.springSpeed = 20
            anim.springBounciness = 20
            tipButton.layer.pop_add(anim, forKey: nil)
            
        }
    }
    

    init() {
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage.init(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        super.init(image: image)
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        //加这个锚点是为了设置动画时回到正确位置,使图片向下移
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        tipButton.setTitle("😄", for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
