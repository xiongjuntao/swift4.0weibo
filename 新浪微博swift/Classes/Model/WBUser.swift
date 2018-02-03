//
//  WBUser.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON


class WBUser: NSObject {
    
    var id: Int64 = 0
    
    var screen_name: String?
    
    var profile_image_url: String?
    
    var verified_type: Int = 0
    
    var mbrank: Int = 0
    
    
    
    init(jsonData: JSON) {
        
        id = jsonData["id"].int64 ?? 0
        screen_name = jsonData["screen_name"].stringValue
        profile_image_url = jsonData["profile_image_url"].stringValue
        verified_type = jsonData["verified_type"].int ?? 0
        mbrank = jsonData["mbrank"].int ?? 0
        
    }
    

}
