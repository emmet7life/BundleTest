//
//  VCNativeMinePageHeaderView.swift
//  BundleTest
//
//  Created by jianli chen on 2020/1/15.
//  Copyright © 2020 jianli chen. All rights reserved.
//

import Foundation
import SnapKit

class VCNativeMinePageHeaderView: UIView {
    
    // MARK: - View
    fileprivate let _contentView = UIView()
    fileprivate let _userHeadImageView = UIImageView()
    fileprivate let _userNameLabel = UILabel()
    fileprivate let _userFlagImageView = UIImageView()
    fileprivate let _userLevelView = UIView()
    
    fileprivate let _coinLabel = UILabel()
    fileprivate let _miaoLabel = UILabel()
    
    fileprivate let _cardView = UIView()
    
    // MARK: - Data
    fileprivate var _lastCardHeightOffset: CGFloat? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupUI()
    }
    
    fileprivate func _setupUI() {
        // Add View
        addSubview(_contentView)
        _contentView.addSubview(_userHeadImageView)
        _contentView.addSubview(_userNameLabel)
        _contentView.addSubview(_userFlagImageView)
        _contentView.addSubview(_userLevelView)
        _contentView.addSubview(_coinLabel)
        _contentView.addSubview(_miaoLabel)
        _contentView.addSubview(_cardView)
        
        // Make Constraint
        _contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        _cardView.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(0)
            $0.height.equalTo(80)
        }
        
        _coinLabel.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.bottom.equalTo(_cardView.snp.top).offset(-16)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        _miaoLabel.snp.makeConstraints {
            $0.leading.equalTo(_coinLabel.snp.trailing).offset(16)
            $0.centerY.equalTo(_coinLabel.snp.centerY)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        _userHeadImageView.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.bottom.equalTo(_coinLabel.snp.top).offset(-16)
            $0.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        // View Debug
        _userHeadImageView.boundDebug(.darkGray)
        _userNameLabel.boundDebug(.green)
        _userFlagImageView.boundDebug(.yellow)
        _userLevelView.boundDebug(.red)
        _coinLabel.boundDebug(.purple)
        _miaoLabel.boundDebug(.black)
        _cardView.boundDebug(.blue)
    }
    
    func updateCardHeightConstraint(_ offset: CGFloat) {
        if let lastOffset = _lastCardHeightOffset, lastOffset == offset {
            return
        }
        _lastCardHeightOffset = offset
        _cardView.snp.updateConstraints { (make) in
            make.height.equalTo(80 + offset)
        }
        updateConstraintsIfNeeded()
    }
    
    func headerViewHeight(_ cardHeight: CGFloat = 80, offset: CGFloat = 0) -> CGFloat {
        // 视图总高度
        // 导航栏高度 + 边距 16 + 头像高度 80 + 边距 16 + 墨币高度 60 + 边距 16 + 卡片高度 80（动态）
        return (UIScreen.isPhoneXSeries ? 88 : 64) + 16 + 80 + 16 + 60 + 16 + cardHeight + offset
    }
}
