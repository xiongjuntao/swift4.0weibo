//
//  WBBaseViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/5.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {
    
    var tableView: UITableView?
    
    var refreshControl: CZRefreshControl?
    
    var isPullup = false
    
    

    //访客视图信息
    var visitorInfoDict: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        WBNetworkManager.shared.userLogin ? loadData() : ()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func loginSuccess() {
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        view = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI(){
        view.backgroundColor = UIColor.white
        //取消自动缩放
        automaticallyAdjustsScrollViewInsets = false
        
        setUpNavigationBar()
        
        
        WBNetworkManager.shared.userLogin ? setupTableView() : setupVisitorView()
        
    }
    
    func setupTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
//        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshControl = CZRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    @objc func loadData() {
        refreshControl?.endRefreshing()
    }
    
}

extension WBBaseViewController{
    
    
    private func setUpNavigationBar() {
        
        //设置navbar整个背景的渲染颜色
        navigationController?.navigationBar.barTintColor = UIColor.init(hexColor: "f6f6f6")
        //设置navbar的字体颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.darkGray]
        //设置系统按钮的文字渲染颜色
        navigationController?.navigationBar.tintColor = UIColor.orange
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
    }
    
    
    
    private func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        view.addSubview(visitorView)
        visitorView.visitorInfo = visitorInfoDict
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    
    @objc private func login () {
        print("登录")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register () {
        print("注册")
    }
    
    
}


extension WBBaseViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = tableView.numberOfSections-1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        if row == (count-1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            loadData()
        }
        
    }
    
}





