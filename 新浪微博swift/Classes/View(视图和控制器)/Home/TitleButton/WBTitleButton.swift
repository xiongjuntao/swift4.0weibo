//
//  WBTitleButton.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/15.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    //title如果是nil, 显示首页
    //不为nil,显示title和箭头
    
    init(title: String?){
        
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        }else {
            setTitle(title! + " ", for: .normal)
            
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)

        sizeToFit()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
              let imageView = imageView else {
            return
        }
        
        // 将 label 的 x 向左移动 imageView 的宽度
        // OC 中不允许直接修改`结构体内部的值`
        // Swift 中可以直接修改
        titleLabel.frame.origin.x = 0
        // 将 imageView 的 x 向右移动 label 的宽度
        imageView.frame.origin.x = titleLabel.bounds.width
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
