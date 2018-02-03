//
//  CZEmoticonCell.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/27.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

@objc protocol CZEmoticonCellDelegate: NSObjectProtocol{
    
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?)
    
}

class CZEmoticonCell: UICollectionViewCell {
    
    weak var delegate: CZEmoticonCellDelegate?
    
    private lazy var tipView = CZEmoticonTipView()
    
    var emoticons: [CZEmoticon]? {
        didSet{
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            contentView.subviews.last?.isHidden = false
            
            for (i, em) in (emoticons ?? []).enumerated() {
                if let btn = contentView.subviews[i] as? UIButton {
                    // 设置图像 - 如果图像为 nil 会清空图像，避免复用
                    btn.setImage(em.image, for: .normal)
                    // 设置 emoji 的字符串 - 如果 emoji 为 nil 会清空 title，避免复用
                    btn.setTitle(em.emoji, for: .normal)
                    btn.isHidden = false
                }
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selectedEmoticonButton(button: UIButton) {
        let tag = button.tag
        print(button)
        var em: CZEmoticon?
        if tag < emoticons?.count ?? 0{
            em = emoticons?[tag]
        }
        print("11111111111")
//        em 要么是选中的模型，如果为 nil 对应的是删除按钮
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
    
    
    @objc private func longGesture (gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        
        guard let button = buttonWithLocation(location: location) else {
            tipView.isHidden = true
            return
        }
        
        switch gesture.state {
        case .began, .changed:
            tipView.isHidden = false
            
            let center = self.convert(button.center, to: window)
            tipView.center = center
            
            if button.tag < emoticons?.count ?? 0 {
                tipView.emoticon = emoticons?[button.tag]
            }
            
            
        case .ended:
            tipView.isHidden = true
            selectedEmoticonButton(button: button)
        case .cancelled, .failed:
            tipView.isHidden = true
            
        default:
            break
        }
        
        
    }
    
    
    private func buttonWithLocation(location: CGPoint) -> UIButton? {
        // 遍历 contentView 所有的子视图，如果可见，同时在 location 确认是按钮
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        
        return nil
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let w = newWindow else {
            return
        }
        w.addSubview(tipView)
        tipView.isHidden = true
        
    }

}



extension CZEmoticonCell {
    
    func setupUI() {
        let rowCount = 3
        let colCount = 7
        
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            contentView.addSubview(btn)
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonButton(button:)), for: .touchUpInside)
            
        }
        
        let removeButton = contentView.subviews.last as! UIButton
        let image = UIImage.init(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: .normal)
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(gesture:)))
        longPress.minimumPressDuration = 0.1
        addGestureRecognizer(longPress)
        
    }
    
}
