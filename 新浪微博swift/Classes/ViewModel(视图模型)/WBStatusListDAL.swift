//
//  WBStatusListDAL.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/29.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation

/// DAL - Data Access Layer 数据访问层
/// 使命：负责处理数据库和网络数据，给 ListViewModel 返回微博的[字典数组]
/// 在调整系统的时候，尽量做最小化的调整！
class WBStatusListDAL {
    /// 从本地数据库或者网络加载数据
    ///
    /// 提示：参数之所以参照网路接口，就是为了保证对原有代码的最小化调整！
    ///
    /// - parameter since_id:   下拉刷新 id
    /// - parameter max_id:     上拉刷新 id
    /// - parameter completion: 完成回调(微博的字典数组，是否成功)
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        // 1. 检查本地数据，如果有，直接返回
        let array = CZSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        if array.count > 0 {
            completion(array, true)
            return
        }
        // 2. 加载网路数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            
            
//            guard let list = list else {
//                completion(nil, isSuccess)
//                return
//            }
            
            CZSQLiteManager.shared.updateStatus(userId: userId, array: list)
            
            completion(list, isSuccess)
        }
        
    }
    
    
}
