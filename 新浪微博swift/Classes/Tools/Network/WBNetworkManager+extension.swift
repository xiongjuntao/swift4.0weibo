//
//  WBNetworkManager+extension.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/8.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation
import SwiftyJSON


extension WBNetworkManager {
    
    
    
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]], _ isSuccess: Bool)->()) {
        
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(method: .get, urlString: urlString, paramters:params as [String : AnyObject]) { (json, isSuccess) in
            
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result ?? [], isSuccess)
            
        }
        

    }
    
    
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        tokenRequest(method: .get, urlString: urlString, paramters: params as [String : AnyObject]) { (json, isSuccess) in
            
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
        
    }
    
}



extension WBNetworkManager {
    
    
    
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURL]
        
        request(method: .post, urlString: urlString, paramters: params as [String : AnyObject]) { (json, isSuccess) in
            
            let jsonData = JSON(json as Any)
            
            self.userAccount = WBUserAccount(jsonData:jsonData)
            self.userAccount.expriresDate = "\(Date(timeIntervalSinceNow: self.userAccount.expires_in))"

            self.loadUserInfo(uid: self.userAccount.uid ?? "", complete: { (dict) in

                self.userAccount.screen_name = dict["screen_name"] as? String
                self.userAccount.avatar_large = dict["avatar_large"] as? String
                self.userAccount.saveAccount()

                completion(true)
            })
        }
        
    }
    
    
    func loadUserInfo(uid: String, complete: @escaping (_ dict: [String: AnyObject])->()) {
        
        
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid]
        
        tokenRequest(method: .get, urlString: urlString, paramters: params as [String : AnyObject]) { (json, isSuccess) in
            
            complete(json as? [String : AnyObject] ?? [:])
        }
    }
    
    
}

//发布微博
extension WBNetworkManager {
    
    func postStates(text: String, image: UIImage?, completion: @escaping (_ result: [String: Any]?, _ isSuccess: Bool)->()) -> () {
        
        // 1. url
        let urlString: String
        
        // 根据是否有图像，选择不同的接口地址
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        } else {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        // 2. 参数字典
        let params = ["status": text]
        
        // 3. 如果图像不为空，需要设置 name 和 data
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        
        tokenRequest(method: .post, urlString: urlString, paramters: params as [String : AnyObject], name: name, data: data) { (json, isSuccess) in
            completion(json as? [String: Any], isSuccess)
        }
        
    }
    
}









