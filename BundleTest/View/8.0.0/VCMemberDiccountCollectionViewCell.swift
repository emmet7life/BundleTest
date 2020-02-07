//
//  VCMemberDiccountCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区 - 会员全场7折
class VCMemberDiscountCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 4.0
        view.contentMode = .scaleAspectFill
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
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
