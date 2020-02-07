//
//  VCMemberLimitFreeCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区 - 会员限免 - Cell
// &
// 超级会员专区 - 超人气作品抢先看 - Cell
class VCMemberLimitFreeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 4.0
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var leftFlagImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemRegularFont(14.0)
        view.textColor = UIColor.colorWithHexRGBA(0x201F38)
        return view
    }()
    
    private(set) lazy var tipLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemRegularFont(12.0)
        view.textColor = UIColor.colorWithHexRGBA(0xF2A800)
        view.layer.backgroundColor = UIColor.colorWithHexRGBA(0xFFEBBC).cgColor
        view.layer.cornerRadius = 11.0
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
        contentView.addSubview(leftFlagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tipLabel)
        
        coverImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-60)
        }
        
        leftFlagImageView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 49.0, height: 16.0))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-31)
            make.leading.equalTo(5.0)
            make.trailing.equalTo(-5.0)
            make.height.equalTo(20.0)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalTo(5.0)
            make.trailing.equalTo(-5.0)
            make.height.equalTo(23.0)
        }
        
        nameLabel.text = "作品名称"
        tipLabel.text = "Svip省198元"
    }
}
