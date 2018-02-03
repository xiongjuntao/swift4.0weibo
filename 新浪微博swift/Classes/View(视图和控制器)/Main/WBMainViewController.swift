//
//  WBMainViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/5.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController {
    
    
    private var timer: Timer?
    

    private lazy var composeButton: UIButton = {
        // 1.创建按钮
        let button = UIButton()
        // 2.设置图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        // 3.设置背景图片
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        
        // 4.监听加号按钮点击
        
        button.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
        // 4.返回按钮
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChildControllers()
        setupComposeButon()
        
        setUpTimer()
        
        // 设置新特性视图
        setupNewfeatureViews()
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin(notifation:)), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
    
    
    @objc private func composeBtnClick() {
        print("撰写按钮")
        
        let v = WBComposeTypeView.composeTypeView()
        v.show { [weak v] (claName) in
            guard let claName = claName,
                let cls = NSClassFromString(Bundle.main.namespace + "." + claName) as? UIViewController.Type else {
                    v?.removeFromSuperview()
                return
            }
            
//            let vc = cls.init()
            
            let storyboard = UIStoryboard.init(name: "WBComposeViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WBComposeViewController")
            
            let nav = UINavigationController.init(rootViewController: vc)
            
            // 让导航控制器强行更新约束 - 会直接更新所有子视图的约束！
            // 提示：开发中如果发现不希望的布局约束和动画混在一起，应该向前寻找，强制更新约束！
            nav.view.layoutIfNeeded()
            self.present(nav, animated: true, completion: {
                v?.removeFromSuperview()
            })
            
        }
    }
    
    @objc private func userLogin (notifation: Notification) {
        
        var when = DispatchTime.now()
        
        if notifation.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时,需要重新登录")
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            let vc = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    deinit {
        timer?.invalidate()
    }

}

// MARK: - 新特性视图处理
extension WBMainViewController {
    /// 设置新特性视图
    private func setupNewfeatureViews() {
        
        
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        v.frame = view.bounds
        view.addSubview(v)
    }
    
    
    private var isNewVersion: Bool {
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        let sandboxVersion =  (try? String(contentsOfFile: path)) ?? ""
        
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        return currentVersion != sandboxVersion
//        return true
    }
}


extension WBMainViewController: UITabBarControllerDelegate{
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        
        let index = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && index == selectedIndex {
            
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                vc.loadData()
            })
            
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}


extension WBMainViewController{
    private func setUpTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        
        if !WBNetworkManager.shared.userLogin {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            UIApplication.shared.applicationIconBadgeNumber = count
        }
        
    }
    
}


extension WBMainViewController{
    
    private func setupComposeButon() {
        tabBar.addSubview(composeButton)
        
        let count: CGFloat = CGFloat(childViewControllers.count);
        let w = tabBar.bounds.width/count - 1
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
    }
        
    //设置子控制器
    private func setUpChildControllers(){
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile:jsonPath)
        
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: Any]] else {
              return
        }

//        let array: [[String: Any]] = [
//            ["clsName": "WBHomeViewController", "title": "首页", "imageName": "home", "visitorInfo": ["imageName": "", "message": "关注一些人,回这里看看有什么惊喜"]],
//            ["clsName": "WBMessageViewController", "title": "消息", "imageName": "message_center", "visitorInfo": ["imageName": "visitordiscover_image_message", "message": "登陆后,别人评论你的微博,发给你的消息,都会在这里收到通知"]],
//            ["clsName": "UIViewController"],
//            ["clsName": "WBDiscoverViewController", "title": "发现", "imageName": "discover", "visitorInfo": ["imageName": "visitordiscover_image_message", "message": "登陆后,最新,最热微博尽在掌握,不再会与实时潮流插肩而过"]],
//            ["clsName": "WBProfileViewController", "title": "我", "imageName": "profile", "visitorInfo": ["imageName": "visitordiscover_image_profile", "message": "登陆后,你的微博,相册,个人资料会显示在这里展示给别人"]]
//        ]
        
        var arrayM = [UIViewController]()
        
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM;
        
    }
    
    private func controller(dict: [String: Any]) -> UIViewController {
        
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
            let visitorDic = dict["visitorInfo"] as? [String: String]
            else {
            return UIViewController()
        }
        
        let vc = cls.init();
        vc.title = title;
        
        vc.visitorInfoDict = visitorDic
        
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], for: .normal)
        
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
        
    }
    
    
    
    
    
}



