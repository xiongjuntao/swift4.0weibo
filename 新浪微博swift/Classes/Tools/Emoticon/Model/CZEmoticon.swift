//
//  CZEmoticon.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/22.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

class CZEmoticon: NSObject {

    /// 表情类型 false - 图片表情 / true - emoji
    var type = false
    /// 表情字符串，发送给新浪微博的服务器(节约流量)
    var chs: String?
    /// 表情图片名称，用于本地图文混排
    var png: String?
    
    /// emoji 的十六进制编码
    var code: String?
    /// 表情使用次数
    var times: Int = 0
    /// emoji 的字符串
    var emoji: String?
    
    /// 表情模型所在的目录
    var directory: String?
    
    var image: UIImage? {
        if type {
            return nil
        }
        
        guard let directory = directory,
        let png = png,
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
        let bundle = Bundle.init(path: path) else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
        
    }
    

    init(jsonData: JSON) {
        chs = jsonData["chs"].stringValue
        png = jsonData["png"].stringValue
        code = jsonData["code"].stringValue
        type = jsonData["type"].boolValue
        
        guard let code = code else {
            return
        }
        
        if code.isEmpty {
            return
        }
        
        let scanner = Scanner(string: code)
        var result: UInt32 = 0
        scanner.scanHexInt32(&result)
        
        emoji = String(Character(UnicodeScalar(result)!))
        
    }
    
    
    /// 将当前的图像转换生成图片的属性文本
    func imageText(font: UIFont) -> NSAttributedString{
        guard let image = image else {
            return NSAttributedString.init(string: "")
        }
        
        let attachment = CZEmoticonAttachment()
        attachment.chs = chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect.init(x: 0, y: -4, width:height , height: height)
        let attrStrM = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attachment))
        
        attrStrM.addAttributes([NSAttributedStringKey.font: font], range: NSRange.init(location: 0, length: 1))
        return attrStrM
        
    }
    
    
    
}
