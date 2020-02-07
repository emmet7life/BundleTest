//
//  VCMineSuperMemberCardViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 我的超级会员 - 会员信息卡片Cell
class VCMineSuperMemberCardViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var memberCardView: VCMineSuperMemberCardView = {
        let view = VCMineSuperMemberCardView()
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
        contentView.addSubview(memberCardView)
        memberCardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
