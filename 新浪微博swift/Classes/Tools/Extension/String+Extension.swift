//
//  String+Extension.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/6.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation

extension String {
    /// String使用下标截取字符串
    /// 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    
    /// 从当前字符串中，提取链接和文本
    /// Swift 提供了`元组`，同时返回多个值
    /// 如果是 OC，可以返回字典／自定义对象／指针的指针
    func cz_href() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern:pattern, options: []),
        let result = regx.firstMatch(in: self, options: [], range: NSRange.init(location: 0, length: count))
        else {
            return nil
        }
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
    }
    
    
}
