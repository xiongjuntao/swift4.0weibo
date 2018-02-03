//
//  WBComposeTypeView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/21.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import pop

class WBComposeTypeView: UIView {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    
    private var completeionBlock: ((_ clsName: String?)->())?
    

    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        v.frame = UIScreen.main.bounds
        v.setupUI()
        return v
    }
    
    
    func show(completion: @escaping (_ clsName: String?)->()) {
        
        completeionBlock = completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        showCurrentView()
        
    }
    
    
    
    @objc private func clickButton(selectedButton: WBComposeTypeButton) {
        print("\(selectedButton)")
        // 1. 判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated() {
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            // x,y 在系统中使用 CGPoint 表示，如果要转换成 id，需要使用 `NSValue` 包装
            let scale = (selectedButton == btn) ? 2 : 0.2
            
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5

            btn.pop_add(scaleAnim, forKey: nil)
            
            // 2> 渐变动画 - 动画组
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                alphaAnim.completionBlock = { _, _ in
                    // 需要执行回调
                    print("完成回调展现控制器")
                  
                    self.completeionBlock?(selectedButton.clsName)
                }
            }
        }
        
        
        
    }
    
    @IBAction func close() {
        hideButtons()
    }
    
    @IBAction func clickReturn() {
        // 1. 将滚动视图滚动到第 1 页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // 2. 让两个按钮合并
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { _ in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
    
    
    
    @objc private func clickMore() {
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

}



private extension WBComposeTypeView {
    
    /// 隐藏按钮动画
    func hideButtons() {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated().reversed() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            // 2> 设置动画属性
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            // 设置时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            // 3> 添加动画
            btn.layer.pop_add(anim, forKey: nil)
            
            // 4> 监听第 0 个按钮的动画，是最后一个执行的
            if i == 0 {
                anim.completionBlock = { _, _ in
                    self.hideCurrentView()
                }
            }
        }
        
        
    }
    
    
    func hideCurrentView() {
        // 1> 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
        // 2> 添加到视图
        pop_add(anim, forKey: nil)
        
        // 3> 添加完成监听方法
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    
    func showCurrentView() {
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        // 2> 添加到视图
        pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    
    func showButtons() {
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            // 弹力系数，取值范围 0~20，数值越大，弹性越大，默认数值为4
            anim.springBounciness = 8
            // 弹力速度，取值范围 0~20，数值越大，速度越快，默认数值为12
            anim.springSpeed = 8
            
            // 设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
    
}



// private 让 extension 中所有的方法都是私有
private extension WBComposeTypeView {
    func setupUI() {
        
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        let width = scrollView.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            addButtons(v: v, idx: i * 6)
            scrollView.addSubview(v)
        }
        
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        
    }
    
    func addButtons(v: UIView, idx: Int){
        let count = 6
        
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    continue
            }
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            v.addSubview(btn)
            
            if let actionName = dict["actionName"] {
                // OC 中使用 NSSelectorFromString(@"clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            btn.clsName = dict["clsName"]
        }
        
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        for (i, btn) in v.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
    
    
}









