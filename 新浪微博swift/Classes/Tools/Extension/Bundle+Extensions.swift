//
//  Bundle+Extensions.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/5.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation


extension Bundle {
    
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}


extension NSObject {
    
    class func cellIdentifier() ->String{
        return NSStringFromClass(self.classForCoder())
    }
    
}
