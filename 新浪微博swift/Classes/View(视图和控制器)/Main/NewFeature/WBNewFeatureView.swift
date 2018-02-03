//
//  WBNewFeatureView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/15.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    class func newFeatureView() -> WBNewFeatureView {
        
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        
        v.frame = UIScreen.main.bounds
        return v
        
    }
    
    override func awakeFromNib() {
        
        let count = 4;
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView.init(image: UIImage.init(named: imageName))
            
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        
        // 指定 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height-20)
        scrollView.bounces = false

        scrollView.delegate = self
        
        // 隐藏按钮
        enterButton.isHidden = true
        
    }
    
    
    @IBAction func enterStatus(_ sender: UIButton) {
        removeFromSuperview()
    }
}

extension WBNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0. 一旦滚动隐藏按钮
        enterButton.isHidden = true
        
        // 1. 计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        // 2. 设置分页控件
        pageControl.currentPage = page
        
        // 3. 分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
    
    
    
}








