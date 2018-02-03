//
//  WBStatusCell.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

@objc protocol WBStatusCellDelegate: NSObjectProtocol {
    @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}


class WBStatusCell: UITableViewCell, FFLabelDelegate {
    
    weak var delegate: WBStatusCellDelegate?

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var memberIconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var vipIconView: UIImageView!
    
    @IBOutlet weak var statusLabel: FFLabel!
    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    
    
    var viewModel: WBStatusViewModel? {
        didSet {
            statusLabel?.attributedText = viewModel?.statusAttrText
            nameLabel.text = viewModel?.status.user.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            sourceLabel.text = viewModel?.source
            timeLabel.text = viewModel?.status.createdDate?.cz_dateDescription
            
            iconView.cz_setImage(urlString: viewModel?.status.user.profile_image_url, placeholderImage: UIImage.init(named: "avatar_default_big"), isAvatar: true)
            toolBar.viewModel = viewModel
            
            pictureView.viewModel = viewModel
            
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层！
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 `栅格化` 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
        
    }
    
    
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        // 判断是否是 URL
        if text.hasPrefix("http://") || text.hasPrefix("https://") {
            delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}



