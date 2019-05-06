//
//  VCFeedListCollectionViewLayout.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/22.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCFeedListCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .horizontal
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let oneScreenWidth = UIScreen.main.bounds.size.width - (8.0 * 2)
        let interitemSpacing = minimumInteritemSpacing
        if let layoutAttributes = super.layoutAttributesForElements(in: rect) {
            for layoutAttr in layoutAttributes {
                let indexPath = layoutAttr.indexPath
                let item = indexPath.item
                // 1. 对8求余 & 除于8的商
                let modOf8 = item % 8
                let quotientOf8 = item / 8
                // 2. 判断在哪一行
                let itemWidth = itemSize.width
                let itemHeight = itemSize.height
                var originX: CGFloat = 0.0
                var originY: CGFloat = 0.0
                if modOf8 <= 3 {
                    // 2.1 第一行
                    originX = CGFloat(modOf8) * itemWidth + CGFloat(modOf8) * interitemSpacing + CGFloat(quotientOf8) * oneScreenWidth
                    originY = 0.0
                } else {
                    // 2.2 第二行: 对4求余
                    let modOf4 = modOf8 % 4
                    originX = CGFloat(modOf4) * itemWidth + CGFloat(modOf4) * interitemSpacing + CGFloat(quotientOf8) * oneScreenWidth
                    originY += itemHeight
                }
                layoutAttr.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: itemSize)
            }
            return layoutAttributes
        }
        return nil
    }
    
}
