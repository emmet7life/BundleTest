//
//  VCSuperMemberSupplymentFooterView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区 - Supplyment 尾部视图
class VCSuperMemberSupplymentFooterView: UICollectionReusableView {
    
    enum LayoutStyle {
        case noneSwitchMoreCenter
        case switchLeftMoreRight
    }
    
    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemMediumFont(18.0)
        return label
    }()
    
    // 换一换
    private lazy var switchResourceBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isScaleDownEffectEnable = true
//        btn.backgroundColor = UIColor.colorWithHexRGBA(0xF4F4F7)
//        btn.setViewCorner(view: btn, cornerRadius: 22)
        btn.layer.backgroundColor = UIColor.colorWithHexRGBA(0xF4F4F7).cgColor
        btn.layer.cornerRadius = 22
        btn.setTitle("换一换", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexRGBA(0x9999A1), for: .normal)
        btn.titleLabel?.font = UIFont.systemRegularFont(12.0)
        return btn
    }()
    
    // 查看更多
    private lazy var lookAtMoreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isScaleDownEffectEnable = true
//        btn.backgroundColor = UIColor.colorWithHexRGBA(0xF4F4F7)
//        btn.setViewCorner(view: btn, cornerRadius: 22)
        btn.layer.backgroundColor = UIColor.colorWithHexRGBA(0xF4F4F7).cgColor
        btn.layer.cornerRadius = 22
        btn.setTitle("查看更多", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexRGBA(0x9999A1), for: .normal)
        btn.titleLabel?.font = UIFont.systemRegularFont(12.0)
        return btn
    }()
    
    // MARK: - Data
    private(set) var layoutStyle: LayoutStyle = .switchLeftMoreRight
    
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
        addSubview(switchResourceBtn)
        addSubview(lookAtMoreBtn)
    }
    
    func updateLayoutStyle(with layoutStyle: LayoutStyle) {
        let viewWidth: CGFloat = self.width
        let viewHeight: CGFloat = self.height
        let btnHeight: CGFloat = 40.0
        let bottom: CGFloat = viewHeight - btnHeight
        let margin: CGFloat = 16.0
        switch layoutStyle {
        case .noneSwitchMoreCenter:
            switchResourceBtn.isHidden = true
            lookAtMoreBtn.isHidden = false
            lookAtMoreBtn.frame = CGRect(x: margin, y: bottom, width: viewWidth - margin * 2, height: btnHeight)
        case .switchLeftMoreRight:
            switchResourceBtn.isHidden = false
            lookAtMoreBtn.isHidden = false
            let xOffset: CGFloat = 23.0
            let btnWidth = (viewWidth - margin * 2 - xOffset) / 2
            switchResourceBtn.frame = CGRect(x: margin, y: bottom, width: btnWidth, height: btnHeight)
            lookAtMoreBtn.frame = CGRect(x: switchResourceBtn.right + xOffset, y: bottom, width: btnWidth, height: btnHeight)
        }
    }
}
