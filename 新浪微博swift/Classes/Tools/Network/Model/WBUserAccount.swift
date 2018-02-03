//
//  WBUserAccount.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/14.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

private let accountFile: NSString = "useraccount.json"

class WBUserAccount: NSObject {
    
    var access_token: String?
    
    var uid: String?
    
    var expires_in: TimeInterval = 0
    
    var expriresDate: String?
    
    var screen_name: String?
    
    var avatar_large: String?
    
    
    init(jsonData: JSON) {
        
        uid = jsonData["uid"].stringValue
        access_token = jsonData["access_token"].stringValue
        expires_in = TimeInterval(jsonData["expires_in"].intValue)
        expriresDate = jsonData["expriresDate"].stringValue
        screen_name = jsonData["screen_name"].stringValue
        avatar_large = jsonData["avatar_large"].stringValue
    }
    
    override init() {
        super.init()
        
    }
    
    
    
    func saveAccount() {
        let dic = dictWithModel()
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
        let filePath = accountFile.cz_appendDocumentDir() else {
            return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
        print("\(filePath)")
        
    }
    
    
    func dictWithModel() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = self.uid
        dict["access_token"] = self.access_token
        dict["expriresDate"] = self.expriresDate
        dict["screen_name"] = self.screen_name
        dict["avatar_large"] = self.avatar_large
        return dict
    }
    
    

}
