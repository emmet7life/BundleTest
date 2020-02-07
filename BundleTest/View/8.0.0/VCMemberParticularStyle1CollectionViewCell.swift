//
//  VCMemberParticularStyle1CollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 会员独享作品容器Cell：样式一
// 场景：
// 1. 超级会员专区：顶部的“VIP独享作品”区块
class VCMemberParticularStyle1CollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    
    private lazy var cyclePageView: TYCyclePagerView = {
        let view = TYCyclePagerView(frame: CGRect.zero)
        view.autoScrollInterval = 0
        view.isInfiniteLoop = true
        view.register(VCMemberParticularCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberParticularCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeBaseView()
    }
    
    private func initializeBaseView() {
        contentView.backgroundColor = .gray
        contentView.addSubview(cyclePageView)
        cyclePageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cyclePageView.dataSource = self
        cyclePageView.delegate = self
    }
    
    // 子组件collectionView的Cell的itemSize的大小
    static var collectionViewCellItemSize: CGSize {
        let itemWidth: CGFloat = screenWidth - 16.0 * 2
        let itemHeight: CGFloat = (itemWidth * 409 / 343) + 53
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    static var cellItemSize: CGSize {
        return CGSize(width: screenWidth, height: VCMemberParticularStyle1CollectionViewCell.collectionViewCellItemSize.height)
    }
}

extension VCMemberParticularStyle1CollectionViewCell: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return 8
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: VCMemberParticularCollectionViewCell.identifier, for: index)
        if let itemCell = cell as? VCMemberParticularCollectionViewCell {
            itemCell.debugTextLabel.text = "\(index)"
        }
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = VCMemberParticularStyle1CollectionViewCell.collectionViewCellItemSize
        layout.itemSpacing = 8
        layout.minimumAlpha = 1.0
        layout.minimumScale = 1.0
        layout.layoutType = .normal
        layout.itemHorizontalCenter = true
        return layout
    }
    
}
