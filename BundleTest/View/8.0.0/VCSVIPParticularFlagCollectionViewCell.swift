//
//  VCSVIPParticularFlagCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 我的超级会员 - SVIP专属标识
class VCSVIPParticularFlagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var superMemberReuseHeaderView: VCSuperMemberReuseHeaderView = {
        let view = VCSuperMemberReuseHeaderView()
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var okBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isScaleDownEffectEnable = true
        btn.layer.backgroundColor = UIColor.colorWithHexRGBA(0xF6F6FA).cgColor
        btn.layer.cornerRadius = 15
        btn.setTitle("现在开通，即刻佩戴 >", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexRGBA(0x29255A), for: .normal)
        btn.titleLabel?.font = UIFont.systemRegularFont(11)
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
        clipsToBounds = true
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(superMemberReuseHeaderView)
        addSubview(okBtn)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        superMemberReuseHeaderView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-28)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.36)
            make.centerX.equalToSuperview()
        }
        
        var option = superMemberReuseHeaderView.viewOption
        option.titleOption = VCUIStyle.MemberSupplymentHeader.textOption(textColor: UIColor.colorWithHexRGBA(0xFDEECE), top: 14)
        option.subTitleOption = VCUIStyle.MemberSupplymentHeader.textOption(textColor: UIColor.colorWithHexRGBA(0xFDEECE), textFont: UIFont.systemRegularFont(13.0), top: 44)
        option.titleText = "SVIP专属标识"
        option.subTitleText = "我是副标题"
        option.imageName = "levelBG"
        option.backgroundColor = .clear
        superMemberReuseHeaderView.updateLayoutOption(option: option)
    }
    
    // 特权icon + SVIP专属标识 +自定义副标题文案
    func updateLayoutOption(option: VCSuperMemberReuseHeaderView.ViewOption) {
        superMemberReuseHeaderView.updateLayoutOption(option: option)
    }
    
    var viewOption: VCSuperMemberReuseHeaderView.ViewOption {
        return superMemberReuseHeaderView.viewOption
    }
}
