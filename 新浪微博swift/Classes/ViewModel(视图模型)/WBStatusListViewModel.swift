//
//  WBStatusListViewModel.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/11.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

private let maxPullupTryTimes = 3

class WBStatusListViewModel {
    
    lazy var statusList = [WBStatusViewModel]()
    
    private var pullUpErrorTime = 0
    
    func loadStatus(pullUp: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        if pullUp && pullUpErrorTime > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        
        let since_id = pullUp ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !pullUp ? 0 : (statusList.last?.status.id ?? 0)
        
//        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
        
        // 让数据访问层加载数据
        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(false, false)
                return
            }

            guard let jsonData = JSON(list).array else{
                completion(false, false)
                return
            }
            
            var array = [WBStatusViewModel]()
            
            if pullUp {
                for json in jsonData {
                    let model = WBStatus(jsonData:json)
                    let viewModel = WBStatusViewModel(model: model)
                    self.statusList.append(viewModel)
                    array.append(viewModel)
                }
                
            }else{
                for json in jsonData.reversed() {
                    let model = WBStatus(jsonData:json)
                    let viewModel = WBStatusViewModel(model: model)
                    self.statusList.insert(viewModel, at: 0)
                    array.append(viewModel)
                }
            }
            
            
            if pullUp && array.count == 0 {
                self.pullUpErrorTime += 1
                completion(isSuccess, false)
            }else{
                
                self.cacheSingleImage(list: array, finished: completion)
            }
            
        }
    }
    
    
    private func cacheSingleImage(list: [WBStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        for vm in list {
            if vm.picURLs?.count != 1 {
                continue
            }
            
            let pic = vm.picURLs?[0].thumbnail_pic
            
            guard let urlString = pic?.replacingOccurrences(of: "http://", with: "https://"),
                let url = URL.init(string: urlString) else{
                    continue
            }
            
            group.enter()
            KingfisherManager.shared.retrieveImage(with: ImageResource.init(downloadURL: url), options: [], progressBlock: nil, completionHandler: { (image, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    length += data.count
                    // 图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                
                group.leave()
            })
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成 \(length / 1024) K")
            finished(true, true)
        }
        
    }
    
    
    
}
