//
//  CZEmoticonToolbar.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/27.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit


@objc protocol CZEmoticonToolbarDelegate: NSObjectProtocol{
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: CZEmoticonToolbar, index: Int)
}

class CZEmoticonToolbar: UIView {
    
    weak var delegate: CZEmoticonToolbarDelegate?
    
    var selectedIndex: Int = 0 {
        didSet{
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            
            (subviews[selectedIndex] as! UIButton).isSelected = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        for (i,btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
    
    @objc private func clickItem(button: UIButton) {
        delegate?.emoticonToolbarDidSelectedItemIndex(toolbar: self, index: button.tag)
    }
    
    
}


private extension CZEmoticonToolbar {
    
    func setupUI() {
        
        let manager = CZEmoticonManager.shared
        
        for (i, p) in manager.packages.enumerated() {
            let btn = UIButton()
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            // 设置按钮的背景图片
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            // 拉伸图像
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5,
                                     left: size.width * 0.5,
                                     bottom: size.height * 0.5,
                                     right: size.width * 0.5)
            
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            btn.setBackgroundImage(image, for: [])
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)
            
            btn.sizeToFit()
            btn.tag = i
            btn.addTarget(self, action: #selector(clickItem(button:)), for: .touchUpInside)
            
            
            addSubview(btn)
        }
        
        // 默认选中第0个按钮
        (subviews[0] as! UIButton).isSelected = true
        
    }
    
}
