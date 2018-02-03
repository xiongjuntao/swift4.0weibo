//
//  CZEmoticonInputView.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/27.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class CZEmoticonInputView: UIView, CZEmoticonToolbarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolbar: CZEmoticonToolbar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var selectedEmoticonCallBack: ((_ emoticon: CZEmoticon?)->())?
    
    class func inputView (selectedEmoticon: @escaping (_ emoticon: CZEmoticon?)->()) -> CZEmoticonInputView {
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! CZEmoticonInputView
        
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        toolbar.delegate = self
        
        let bundle = CZEmoticonManager.shared.bundle
        guard let normalImage = UIImage.init(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
        let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) else {
            return
        }
        
        UIPageControl.cz_ivarsList()
        // 使用 KVC 设置私有成员属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
    }
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: CZEmoticonToolbar, index: Int) {
        // 让 collectionView 发生滚动 -> 每一个分组的第0页
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        toolbar.selectedIndex = index
        
    }

}



extension CZEmoticonInputView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        // 2. 获取当前显示的 cell 的 indexPath
        let paths = collectionView.indexPathsForVisibleItems
        // 3. 判断中心点在哪一个 indexPath 上，在哪一个页面上
        var targetIndexPath: IndexPath?
        for indexPath in paths {
            // 1> 根据 indexPath 获得 cell
            let cell = collectionView.cellForItem(at: indexPath)
            // 2> 判断中心点位置
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
            
        }
        
        guard let target = targetIndexPath else {
            return
        }
        // 4. 判断是否找到 目标的 indexPath
        // indexPath.section => 对应的就是分组
        toolbar.selectedIndex = target.section
        // 5. 设置分页控件
        // 总页数，不同的分组，页数不一样
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
        
    }
    
    
}


extension CZEmoticonInputView: CZEmoticonCellDelegate{
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?) {
        
        selectedEmoticonCallBack?(em)
        
        guard let em = em else {
            return
        }
        
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        CZEmoticonManager.shared.recentEmoticon(em: em)
        //刷新数据 - 第 0 组
        var indexSet = IndexSet()
        indexSet.insert(0)
        
        collectionView.reloadSections(indexSet)
        
    }
}






