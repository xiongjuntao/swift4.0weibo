//
//  WBVisitorView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/7.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    private lazy var iconView : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    private lazy var maskIconView : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    private lazy var houseIconView : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    private lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.text = "关注一些人,回这里看看有什么惊喜"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton: UIButton = {
        // 1.创建按钮
        let button = UIButton()
        // 2.设置图片
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        //        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .normal)
        // 4.监听加号按钮点击
        
        return button
    }()
    
    lazy var loginButton: UIButton = {
        // 1.创建按钮
        let button = UIButton()
        // 2.设置图片
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        //        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .normal)
        // 4.监听加号按钮点击
        
        return button
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //设置访客视图信息
    var visitorInfo: [String: String]? {
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            houseIconView.isHidden = true
            maskIconView.isHidden = true
            
            
        }
    }
    
    
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        anim.isRemovedOnCompletion = false
        iconView.layer.add(anim, forKey: nil)
    }
    
    
}


extension WBVisitorView {
    func setupUI() {
        backgroundColor = UIColor.init(hexColor: "ededed", a: 1)
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin: CGFloat = 20.0
        
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        // 3> 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        
        // 4> 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        
        // 5> 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        // 6> 遮罩图像
        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中 () 指定的常数影射关系
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrics = ["spacing": 20]

        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
    }
}






