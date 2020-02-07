//
//  VCMemberBenefitsGiftRectCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 我的超级会员 - SVIP会员福利 区块Cell
class VCMemberBenefitsGiftRectCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8.0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .white
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
        contentView.backgroundColor = .white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.register(VCMemberBenefitsGiftCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberBenefitsGiftCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // 子组件collectionView的Cell的itemSize的大小
    static var collectionViewCellItemSize: CGSize {
        let itemWidth = (screenWidth - 16 - 12) / (149.0 / 202.0 + 1.0)
        let itemHeight: CGFloat = max(246, itemWidth * 246 / 202)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    static var cellItemSize: CGSize {
        return CGSize(width: screenWidth, height: VCMemberBenefitsGiftRectCollectionViewCell.collectionViewCellItemSize.height)
    }
}

extension VCMemberBenefitsGiftRectCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberBenefitsGiftCollectionViewCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return VCMemberBenefitsGiftRectCollectionViewCell.collectionViewCellItemSize
    }
}
