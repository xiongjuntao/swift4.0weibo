//
//  WBComposeTextView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/26.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    
    private lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    
    

    @objc private func textChanged() {
        placeholderLabel.isHidden = self.hasText
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension WBComposeTextView{
    
    //返回 textView 对应的纯文本的字符串[将属性图片转换成文字]
    var emoticonText: String {
        
        guard let attrStr = attributedText else {
            return ""
        }
        
        var result = String()
        
        
        attrStr.enumerateAttributes(in: NSRange.init(location: 0, length: attrStr.length), options: []) { (dict, range, _) in
            // 如果字典中包含 NSAttachment `Key` 说明是图片，否则是文本
            // 下一个目标：从 attachment 中如果能够获得 chs 就可以了！
            
            if let attachment = dict[NSAttributedStringKey.attachment] as? CZEmoticonAttachment {
                result += attachment.chs ?? ""
            }else{
                let subStr = (attrStr.string as NSString).substring(with: range)
                result += subStr
            }
        }
        
        return result
    }
    
    
    func insertEmoticon(em: CZEmoticon?) {
        //em == nil 是删除按钮
        guard let em = em else {
            
            deleteBackward()
            return
        }
        //emoji 字符串
        if let emoji = em.emoji, let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            return
        }
        
        //代码执行到此，都是图片表情
        //获取表情中的图像属性文本
        let imageText = em.imageText(font: font!)
        //获取当前 textView 属性文本 => 可变的
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        //图像的属性文本插入到当前的光标位置
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        // 记录光标位置
        let range = selectedRange
        // 设置文本
        attributedText = attrStrM
        // 恢复光标位置，length 是选中字符的长度，插入文本之后，应该为 0
        selectedRange = NSRange.init(location: range.location + 1, length: 0)
        
        // 让代理执行文本变化方法 - 在需要的时候，通知代理执行协议方法！
        delegate?.textViewDidChange?(self)
        
        textChanged()
    }
}


private extension WBComposeTextView {
    
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint.init(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        
    }
    
    
    
}
