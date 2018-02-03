//
//  WBNetworkManager.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/8.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let accountFile: NSString = "useraccount.json"

class WBNetworkManager {
    
    static let shared = WBNetworkManager()
    
    
//    lazy var userAccount = WBUserAccount()
    
    lazy var userAccount: WBUserAccount = {
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any] else{
                return WBUserAccount()
        }

        let jsonData = JSON.init(dict as Any)
        let model = WBUserAccount(jsonData: jsonData)


        if model.expriresDate?.caseInsensitiveCompare("\(NSDate())") != .orderedDescending {

            print("账户过期")

            // 清空 token
            model.access_token = nil
            model.uid = nil
            // 删除帐户文件
            _ = try? FileManager.default.removeItem(atPath: path)
        }

        return model
        
//        return WBUserAccount()
    }()
    
    
//    var accessToken: String? //= "2.00oGsBrDXYFhuB11026ea2122Vok7C"
//
//    var uid: String? = "5365823342"
    
    var userLogin: Bool{
        return userAccount.access_token != nil
    }
    
    
    func tokenRequest(method: HTTPMethod, urlString: String, paramters: [String: AnyObject]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool)->()) {
        
        guard let token = userAccount.access_token else {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            
            completion(nil, false)
            return
        }
        
        var paramters = paramters
        if paramters == nil {
            paramters = [String: AnyObject]()
        }
        
        paramters!["access_token"] = token as AnyObject
        
        // 3> 判断 name 和 data
        if let name = name, let data = data {
            // 上传文件
            upload(method: .post, urlString: urlString, paramters: paramters, name: name, data: data, completion: completion)
        } else {
            
            // 调用 request 发起真正的网络请求方法
            // request(URLString: URLString, parameters: parameters, completion: completion)
            request(method: method, urlString: urlString, paramters: paramters, completion: completion)
        }
        
    }
    
    
    
    func request(method: HTTPMethod, urlString: String, paramters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool)->()) {
        
        Alamofire.request(urlString, method: method, parameters: paramters).responseJSON { (response) in
            
            if response.response?.statusCode == 403 {
                print("Token 过期了")
                
                // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                    object: "bad token")
                completion(nil, false)
                return
            }
            
            guard let result = response.result.value else {
                completion(response.result.error as AnyObject, false)
                return
            }
            
            completion(result as AnyObject, true)
            
        }
        
    }
    
    
    /// 上传图片
    func upload(method: HTTPMethod, urlString: String, paramters: [String: AnyObject]?, name: String, data: Data, completion: @escaping (_ json: AnyObject?,_ isSuccess: Bool)->()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: name, fileName: "abc.png", mimeType: "application/octet-stream")
            
        }, to: urlString) { (encodingResult) in
            switch encodingResult {
                case .success(let upload, _, _):
                
                    upload.responseJSON { response in
                        
                        if response.response?.statusCode == 403 {
                            print("Token 过期了")
                            
                            // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                            NotificationCenter.default.post(
                                name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                                object: "bad token")
                            completion(nil, false)
                            return
                        }
                        
                        guard let result = response.result.value else {
                            completion(response.result.error as AnyObject, false)
                            return
                        }
                        
                        completion(result as AnyObject, true)
                        
                    }
                    
                    break
                
                case .failure(let encodingError):
                
                
                    completion(nil, false)
                    break
                
            }
        }
        
    }
    
}





