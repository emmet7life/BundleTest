//
//  VCMemberBenefitsGiftCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 我的超级会员 - SVIP会员福利
class VCMemberBenefitsGiftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var backgroundMaskView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemMediumFont(18.0)
        view.textColor = UIColor.white
        return view
    }()
    
    private(set) lazy var giftFlagImageView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 30.0
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var tip1Label: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.systemMediumFont(14.0)
        view.textColor = UIColor.white
        return view
    }()
    
    private(set) lazy var tip2Label: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = UIFont.systemRegularFont(10.0)
        view.textColor = UIColor.white
        view.lineBreakMode = .byTruncatingTail
        view.numberOfLines = 3
        return view
    }()
    
    private lazy var giftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isScaleDownEffectEnable = true
        btn.layer.backgroundColor = UIColor.colorWithHexRGBA(0xFFDDA1).cgColor
        btn.layer.cornerRadius = 22
        btn.setTitle("立即开通", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexRGBA(0xC98000), for: .normal)
        btn.titleLabel?.font = UIFont.systemMediumFont(16)
        return btn
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
        contentView.layer.cornerRadius = 12.0
        contentView.layer.backgroundColor = UIColor.purple.cgColor
        
        contentView.addSubview(backgroundMaskView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(giftFlagImageView)
        contentView.addSubview(tip1Label)
        contentView.addSubview(tip2Label)
        contentView.addSubview(giftBtn)
        
        backgroundMaskView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(25)
        }
        
        giftFlagImageView.snp.makeConstraints { (make) in
            make.top.equalTo(41)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        tip1Label.snp.makeConstraints { (make) in
            make.top.equalTo(giftFlagImageView.snp.bottom).offset(6)
            make.leading.equalTo(10.0)
            make.trailing.equalTo(-10.0)
            make.height.equalTo(20.0)
        }
        
        tip2Label.snp.makeConstraints { (make) in
            make.top.equalTo(tip1Label.snp.bottom).offset(4)
            make.leading.equalTo(8.0)
            make.trailing.equalTo(-8.0)
        }
        
        giftBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(30.0)
            make.trailing.equalTo(-30.0)
            make.bottom.equalTo(-14.0)
            make.height.equalTo(42)
        }
        
        titleLabel.text = "福利"
        tip1Label.text = "福利说明 :"
        tip2Label.text = "开通超级会员，开通超级会员，开通超级会员，开通超级会员，开通超级会员，开通超级会员，开通超级会员，开通超级会员。"
    }
    
}
