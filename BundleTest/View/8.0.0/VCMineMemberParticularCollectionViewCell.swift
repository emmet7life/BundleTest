//
//  VCMineMemberParticularCollectionViewCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

// 我的超级会员 - SVIP独享作品
class VCMineMemberParticularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = className()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemMediumFont(18.0)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private(set) lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemRegularFont(12.0)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private(set) lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemMediumFont(33.0)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private(set) lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemRegularFont(11.0)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
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
        clipsToBounds = true
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(storyLabel)
        addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 74, height: 30))
            make.bottom.equalToSuperview()
            make.trailing.equalTo(-8)
        }
        
        storyLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 74, height: 40))
            make.bottom.equalTo(tipLabel.snp.top)
            make.trailing.equalTo(-8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(storyLabel.snp.leading).offset(8)
            make.height.equalTo(22)
            make.bottom.equalTo(subTitleLabel.snp.top).offset(6)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(tipLabel.snp.leading).offset(8)
            make.height.equalTo(22)
            make.bottom.equalTo(-8)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = "漫画名称"
        subTitleLabel.text = "副标题"
        storyLabel.text = "9.0"
        tipLabel.text = "故事指数"
    }
}
