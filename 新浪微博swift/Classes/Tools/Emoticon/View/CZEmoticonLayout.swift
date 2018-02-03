//
//  CZEmoticonLayout.swift
//  新浪微博swift
//
//  Created by xjt on 2017/12/27.
//  Copyright © 2017年 xjt. All rights reserved.
//

import UIKit

class CZEmoticonLayout: UICollectionViewFlowLayout {
    
    
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        scrollDirection = .horizontal
        
    }

}


