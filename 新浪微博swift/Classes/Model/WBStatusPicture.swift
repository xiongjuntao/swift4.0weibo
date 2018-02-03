//
//  WBStatusPicture.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

class WBStatusPicture: NSObject {
    
    
    var largePic: String?
    
    var thumbnail_pic: String?

    init(jsonData: JSON) {

        largePic = jsonData["largePic"].stringValue
        thumbnail_pic = jsonData["thumbnail_pic"].stringValue
        
        // print(thumbnail_pic)
        // 设置大尺寸图片
        largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")

        // 更改缩略图地址
        thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        
    }
}
