//
//  WBStatus.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/11.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

class WBStatus: NSObject {

    var id: Int64 = 0
    /// 微博信息内容
    var text: String?
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    
    var created_at: String?
    /// 微博创建日期
    var createdDate: Date?
    
    var source: String?
  
    var user: WBUser
    
    var pic_urls: [WBStatusPicture]?
    
    var retweeted_status: WBStatus?
    
    
    init(jsonData: JSON) {
        id = jsonData["id"].int64 ?? 0
        text = jsonData["text"].stringValue
        source = jsonData["source"].stringValue
        created_at = jsonData["created_at"].stringValue
        reposts_count = jsonData["reposts_count"].int ?? 0
        comments_count = jsonData["comments_count"].int ?? 0
        attitudes_count = jsonData["attitudes_count"].int ?? 0
        user = WBUser(jsonData: jsonData["user"])
        
        createdDate = Date.cz_sinaDate(string: created_at ?? "")
        
        var array = [WBStatusPicture]()
        if let arr = jsonData["pic_urls"].array {
            for picture in arr {
                array.append(WBStatusPicture(jsonData: picture))
            }
        }
        pic_urls = array
        
        let json = jsonData["retweeted_status"]
        if json != JSON.null {
           retweeted_status = WBStatus(jsonData: jsonData["retweeted_status"])
        }
        
        
        
    }
    
    
    
}
