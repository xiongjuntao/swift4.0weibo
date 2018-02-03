//
//  CZEmoticonManager.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/22.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SwiftyJSON

class CZEmoticonManager {
    
    static let shared = CZEmoticonManager()
    
    /// 表情包的懒加载数组 - 第一个数组是最近表情，加载之后，表情数组为空
    lazy var packages = [CZEmoticonPackage]()
    
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        
        return Bundle(path: path!)!
    }()
    
    private init(){
        loadPackages()
    }
    
    /// 添加最近使用的表情
    ///
    /// - parameter em: 选中的表情
    func recentEmoticon(em: CZEmoticon) {
        em.times += 1
        
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.append(em)
        }
        
        //根据使用次数排序，使用次数高的排序靠前
        // 对当前数组排序
        packages[0].emoticons.sort { (em1, em2) -> Bool in
            return em1.times > em2.times
        }
        
        //判断表情数组是否超出 20，如果超出，删除末尾的表情
        if packages[0].emoticons.count > 20 {
            packages[0].emoticons.removeSubrange(20..<packages[0].emoticons.count)
        }
        
        
        
    }

}



extension CZEmoticonManager {
    
    /// 将给定的字符串转换成属性文本
    ///
    /// 关键点：要按照匹配结果倒序替换属性文本！
    ///
    /// - parameter string: 完整的字符串
    ///
    /// - returns: 属性文本
    func emoticinString(string: String, font: UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString.init(string: string)
        
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression.init(pattern: pattern, options: []) else {
            return attrString
        }
        let matches = regx.matches(in: string, options: [], range: NSRange.init(location: 0, length: attrString.length))
        
        for m in matches.reversed() {
            let r = m.range(at: 0)
            let subStr = (attrString.string as NSString).substring(with: r)
            if let em = CZEmoticonManager.shared.findEmoticon(string: subStr) {
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
            
        }
        
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: font], range: NSRange.init(location: 0, length: attrString.length))
        
        return attrString
        
        
    }
    
    
    func findEmoticon(string: String) -> CZEmoticon? {
        
        for p in packages {
            
            let result = p.emoticons.filter({ (em) -> Bool in
                return em.chs == string
            })
            
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
        
    }
}



private extension CZEmoticonManager {
    
    func loadPackages() {
        
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
        let bundle = Bundle.init(path: path),
        let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
        let array = NSArray.init(contentsOfFile: plistPath) as? [[String: String]],
        let jsonData = JSON(array).array else {
            return
        }
        
        for json in jsonData {
            let model = CZEmoticonPackage(jsonData:json)
            packages.append(model)
        }
        
        
        
    }
        
        
    
}


