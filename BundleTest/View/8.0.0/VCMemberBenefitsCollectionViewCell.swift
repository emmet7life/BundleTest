//
//  VCMemberBenefitsCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/11.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 会员权益 - 权益Cell
class VCMemberBenefitsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()

    // MARK: - View
    private(set) lazy var memberBenefitsItemView: VCMemberBenefitsItemView = {
        let view = VCMemberBenefitsItemView()
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
        contentView.addSubview(memberBenefitsItemView)
        memberBenefitsItemView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
