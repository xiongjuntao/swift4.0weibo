//
//  WeiBoCommon.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/13.
//  Copyright © 2017年 xjt. All rights reserved.
//

import Foundation

let WBAppKey = "1753877113"

let WBAppSecret = "986f65b316b19b5433712879cb3eb2a8"

let WBRedirectURL = "http://baidu.com"


/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

/// 微博 Cell 浏览照片通知
let WBStatusCellBrowserPhotoNotification = "WBStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let WBStatusCellBrowserPhotoSelectedIndexKey = "WBStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let WBStatusCellBrowserPhotoURLsKey = "WBStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let WBStatusCellBrowserPhotoImageViewsKey = "WBStatusCellBrowserPhotoImageViewsKey"




// 配图视图外侧的间距
let WBStatusPictureViewOutterMargin = CGFloat(12)
// 配图视图内部图像视图的间距
let WBStatusPictureViewInnerMargin = CGFloat(3)
// 视图的宽度的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureViewOutterMargin
// 每个 Item 默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3
