//
//  WBStatusToolBar.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/18.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    /// 转发
    @IBOutlet weak var retweetedButton: UIButton!
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞
    @IBOutlet weak var likeButton: UIButton!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    
    

}
