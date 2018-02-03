//
//  WBStatusViewModel.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit



//单条微博的视图模型
class WBStatusViewModel {
    
    var status: WBStatus
    /// 会员图标 - 存储型属性(用内存换 CPU)
    var memberIcon: UIImage?
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var vipIcon: UIImage?
    /// 转发文字
    var retweetedStr: String?
    /// 评论文字
    var commentStr: String?
    /// 点赞文字
    var likeStr: String?
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    var picURLs: [WBStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    var source: String?
    
    /// 转发文字的属性文本
    var retweetedAttrText: NSAttributedString?
    /// 正文属性文本
    var statusAttrText: NSAttributedString?
    
    var rowHeight: CGFloat = 0
    
    
    init(model: WBStatus) {
        
        self.status = model
        
        if model.user.mbrank > 0 && model.user.mbrank < 7 {
            let imageName = "common_icon_membership_level\(model.user.mbrank)"
            memberIcon = UIImage.init(named: imageName)
        }
        
        // 认证图标
        switch model.user.verified_type{
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        // 设置被转发微博的属性文本
        var retweetStr = "@" + (status.retweeted_status?.user.screen_name ?? "") + ":"
        retweetStr = " \(retweetStr)" + (status.retweeted_status?.text ?? "")
        retweetedAttrText = CZEmoticonManager.shared.emoticinString(string: retweetStr, font: retweetedFont)
        // 微博正文的属性文本
        statusAttrText = CZEmoticonManager.shared.emoticinString(string: model.text ?? "", font: originalFont)
        
        
        source = "来源于" + (model.source?.cz_href()?.text ?? "")
        
        
        updateRowHeight()
    }
    
    
    func updateRowHeight() {
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        
        height = 2 * margin + iconHeight + margin
        
        if let text = statusAttrText {
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        //是否转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            
            if let text = retweetedAttrText {
               height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
            
        }
        
        height += pictureViewSize.height
        height += margin
        height += toolbarHeight
        
        rowHeight = height
        
    }
    
    
    private func calcPictureViewSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize()
        }
        
        let row = (count! - 1) / 3 + 1
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        
        let maxWidth: CGFloat = 200
        let minWidth: CGFloat = 40
        // 过宽图像处理
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 过窄图像处理
        if size.width < minWidth {
            size.width = minWidth
            // 要特殊处理高度，否则高度太大，会印象用户体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        // 过高图片处理，图片填充模式就是 scaleToFill，高度减小，会自动裁切
        if size.height > 200 {
            size.height = 200
        }
        
        
        size.height += WBStatusPictureViewOutterMargin
        
        pictureViewSize = size
        
        updateRowHeight()
    }
    

    
    private func countString(count: Int, defaultStr: String) -> String {
        
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    
}




