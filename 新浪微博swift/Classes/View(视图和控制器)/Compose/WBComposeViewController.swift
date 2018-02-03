//
//  WBComposeViewController.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/21.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: WBComposeTextView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    lazy var emoticonView: CZEmoticonInputView = CZEmoticonInputView.inputView { [weak self] (emoticon) in
        
        self?.textView.insertEmoticon(em: emoticon)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("发布", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setBackgroundImage(UIImage.init(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), for: .disabled)
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        btn.addTarget(self, action: #selector(postStates), for: .touchUpInside)
        return btn
    }()
    
    
    @objc func postStates() {
        print("发布按钮")
        
        let text = textView.emoticonText
        let image: UIImage? = nil //UIImage(named: "icon_small_kangaroo_loading_1")
        
        WBNetworkManager.shared.postStates(text: text, image: image) { (result, isSuccess) in
            
            SVProgressHUD.setDefaultStyle(.dark)
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.showInfo(withStatus: message)
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.close()
                    SVProgressHUD.setDefaultStyle(.light)
                })
            }
            
        }
        
    }
    
    
    @objc private func keyboardChanged(notification: NSNotification) {
        print(notification)
        
        guard let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        
        // 3. 更新底部约束
        toolbarBottomCons.constant = -offset
        // 4. 动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }

    }
    
    
    @objc private func emoticonKeyboard () {
        // 1> 测试键盘视图 - 视图的宽度可以随便，就是屏幕的宽度
//        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
//        keyboardView.backgroundColor = UIColor.blue
        
        // 2> 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        // 3> !!!刷新键盘视图
        textView.reloadInputViews()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}



extension WBComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
    
}


private extension WBComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupToolbar()
    }
    
    
    func setupToolbar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else {
                continue
            }
            let image = UIImage.init(named: imageName)
            let imageHL = UIImage.init(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            
            // 判断 actionName
            if let actionName = s["actionName"] {
                // 给按钮添加监听方法
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 删除末尾弹簧
        items.removeLast()
        toolbar.items = items
        
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        sendButton.isEnabled = false
        
        navigationItem.titleView = titleLabel
    }
    
}





