//
//  CZLabel.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/25.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class CZLabel: UILabel {

    private lazy var textStorage = NSTextStorage()
    
    private lazy var layoutManager = NSLayoutManager()
    
    private lazy var textContainer = NSTextContainer()
    
    //重写属性
    override var text: String?{
        didSet{
            prepareTextContent()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.size = bounds.size
    }
    
    
    //绘制文本
    override func drawText(in rect: CGRect) {
        let range = NSRange.init(location: 0, length: textStorage.length)
        
        //绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        //绘制字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        //获取当前点中字符的索引
        let idx = layoutManager.glyphIndex(for: location, in: textContainer)
        for r in urlRanges ?? [] {
            
            if NSLocationInRange(idx, r) {
                print("需要高亮")
                
                textStorage.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: r)
                //重绘制
                setNeedsDisplay()
            }else{
                print("没戳着")
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    

}


private extension CZLabel {
    func prepareTextSystem() {
        isUserInteractionEnabled = true
        
        prepareTextContent()
        //设置关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
    }
    
    //准备文本内容
    func prepareTextContent() {
        
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        }else if let text = text {
            textStorage.setAttributedString(NSAttributedString.init(string: text))
        }else{
            textStorage.setAttributedString(NSAttributedString.init(string: ""))
        }
        
        for r in urlRanges ?? [] {
            textStorage.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.backgroundColor: UIColor.init(white: 0.9, alpha: 0.1)], range: r)
        }
        
    }
}

//正则表达式函数
private extension CZLabel {
    
    var urlRanges: [NSRange]? {
        
        let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        guard let regx = try? NSRegularExpression.init(pattern: pattern, options: []) else {
            return nil
        }
        
        let matches = regx.matches(in: textStorage.string, options: [], range: NSRange.init(location: 0, length: textStorage.length))
        var ranges = [NSRange]()
        
        for m in matches {
            ranges.append(m.range(at: 0))
        }
        
        
        return []
    }
}







