//
//  VCMemberBrainwashCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区 - 安利墙 - Cell
class VCMemberBrainwashItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var memberBrainwashItemView: VCMemberBrainwashItemView = {
        let view = VCMemberBrainwashItemView()
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
        contentView.addSubview(memberBrainwashItemView)
        memberBrainwashItemView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
