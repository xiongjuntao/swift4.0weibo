//
//  WBHomeViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/5.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit


private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController, WBStatusCellDelegate {

    private lazy var statusList = [String]()
    private let a = "cellId"
    
    private lazy var listViewModel = WBStatusListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(browserPhoto(notification:)),
            name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification),
            object: nil)
    }

    override func setupTableView(){
        super.setupTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        tableView?.register(UINib.init(nibName: "WBStatusCell", bundle: nil), forCellReuseIdentifier: WBStatusCell.cellIdentifier())
        tableView?.register(UINib.init(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    
    private func setupNavTitle() {
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        
        button.addTarget(self, action: #selector(clickTitleButton(button:)), for: .touchUpInside)
        
        navigationItem.titleView = button
    }
    
    
    @objc func clickTitleButton(button: UIButton) {
        button.isSelected = !button.isSelected
        
    }
    
    
    override func loadData() {
     
        refreshControl?.beginRefreshing()
        
        listViewModel.loadStatus(pullUp: self.isPullup) { (isSuccess, shouldRefresh) in
            
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
            
    
        }
    }
    
    @objc private func showFriends() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func browserPhoto(notification: Notification) {
        guard let selectedIndex = notification.userInfo?[WBStatusCellBrowserPhotoSelectedIndexKey] as? Int,
        let urls = notification.userInfo?[WBStatusCellBrowserPhotoURLsKey] as? [String],
         let imageViewList = notification.userInfo?[WBStatusCellBrowserPhotoImageViewsKey] as? [UIImageView] else {
            return
        }
        
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViewList)
        present(vc, animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellId = (viewModel.status.retweeted_status != nil) ? retweetedCellId : WBStatusCell.cellIdentifier()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
    
        cell.delegate = self
        cell.selectionStyle = .none
        
        cell.viewModel = viewModel;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
    
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        
        let vc = WBWebViewController()
        vc.urlString = urlString
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



