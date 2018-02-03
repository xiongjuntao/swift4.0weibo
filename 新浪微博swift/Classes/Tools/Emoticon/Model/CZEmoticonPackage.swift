//
//  CZEmoticonPackage.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/22.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

class CZEmoticonPackage: NSObject {
    

    /// 表情包的分组名
    var groupName: String?
    /// 背景图片名称
    var bgImageName: String?
    /// 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
    var directory: String?
    
    
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons = [CZEmoticon]()
    
    /// 表情页面数量
    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    /// 从懒加载的表情包中，按照 page 截取最多 20 个表情模型的数组
    /// 例如有 26 个表情
    /// page == 0，返回 0~19 个模型
    /// page == 1，返回 20~25 个模型
    func emoticon(page: Int) -> [CZEmoticon] {
        
        let count = 20
        let location = page * count
        var length = count
        
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange.init(location: location, length: length)
        let subArray = (emoticons as NSArray).subarray(with: range)
        return subArray as! [CZEmoticon]
    }
    
    
    init(jsonData: JSON) {
        super.init()
        
        groupName = jsonData["groupName"].stringValue
        bgImageName = jsonData["bgImageName"].stringValue
        directory = jsonData["directory"].stringValue
        
        guard let directory = directory,
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
        let bundle = Bundle.init(path: path),
        let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
        let array = NSArray.init(contentsOfFile: infoPath) as? [[String: String]],
        let jsonData = JSON(array).array else {
            return
        }
        
        for json in jsonData {
            let model = CZEmoticon(jsonData:json)
            model.directory = directory
            emoticons.append(model)
        }
        
    }

}
