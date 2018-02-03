//
//  UIColor+Extension.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/6.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import Foundation


extension UIColor {
    /// 哈希值标注
    convenience init(hexColor: String, a: CGFloat = 1.0) {
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        Scanner(string: hexColor[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColor[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColor[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: a)
    }
    
    
    
    /// RGB色值标注
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a:CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
