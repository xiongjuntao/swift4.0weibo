//
//  WBStatusPictureView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    var viewModel: WBStatusViewModel? {
        didSet{
            calcViewSize()
            urls = viewModel?.picURLs
        }
    }
    
    private func calcViewSize() {
        
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height-WBStatusPictureViewOutterMargin)
        }else{
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        }
        
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
     private var urls: [WBStatusPicture]? {
        didSet{
            
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                // 判断是否是 gif，根据扩展名
                iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
                
                iv.isHidden = false
                index += 1
            }
            
        }
    }
    
    
    @objc private func tapImageView(tap: UITapGestureRecognizer) {
        guard let iv = tap.view, let picURLs = viewModel?.picURLs else {
            return
        }
        
        var selectedIndex = iv.tag
        
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        
        var urls = [String]()
        for url in picURLs {
            urls.append(url.largePic ?? "")
        }
        
//        let urls = (picURLs as NSArray).value(forKey: "largePic") as! [String]
        
        var imageViewList = [UIImageView]()
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        
        // 发送通知
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification),
            object: self,
            userInfo: [WBStatusCellBrowserPhotoURLsKey: urls,
                       WBStatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
                       WBStatusCellBrowserPhotoImageViewsKey: imageViewList])
        
        
    }
    
    override func awakeFromNib() {
        
        setupUI()
    }
    
    

}



extension WBStatusPictureView {
    
    private func setupUI(){
        
        backgroundColor = superview?.backgroundColor
        
        clipsToBounds = true
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0..<count*count {
            let iv = UIImageView()
    
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
            iv.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(tap:)))
            iv.addGestureRecognizer(tap)
            iv.tag = i
            
            addGifView(iv: iv)
        }
        
    }
    
    
    /// 向图像视图添加 gif 提示图像
    private func addGifView(iv: UIImageView) {
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        iv.addSubview(gifImageView)
        
        // 自动布局
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: iv,
            attribute: .right,
            multiplier: 1.0,
            constant: 0))
        iv.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: iv,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
    }
    
    
}
