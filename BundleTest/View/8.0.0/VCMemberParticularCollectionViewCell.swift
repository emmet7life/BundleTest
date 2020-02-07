//
//  VCMemberParticularCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// VIP独享作品CollectionViewCell
// 场景：
// 1. 超级会员专区页
class VCMemberParticularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = VCMemberParticularCollectionViewCell.className()
    
    // MARK: - View
    private(set) lazy var memberParticularItemView: VCMemberParticularItemView = {
        let view = VCMemberParticularItemView()
        return view
    }()
    
    private(set) lazy var debugTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemMediumFont(80.0)
        return label
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
        contentView.addSubview(memberParticularItemView)
        memberParticularItemView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(debugTextLabel)
        debugTextLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
