//
//  VCFeedListBaseView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/22.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCFeedListBaseView: VCLoadFromNibBaseView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
}
