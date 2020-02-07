//
//  VCSuperMemberSupplymentHeaderView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区 - Supplyment 头部视图
class VCSuperMemberSupplymentHeaderView: UICollectionReusableView {

    static let identifier = className()
    
    // MARK: - View
    private(set) lazy var superMemberReuseHeaderView: VCSuperMemberReuseHeaderView = {
        let view = VCSuperMemberReuseHeaderView()
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
        clipsToBounds = true
        backgroundColor = .white
        addSubview(superMemberReuseHeaderView)
        superMemberReuseHeaderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateLayoutOption(option: VCSuperMemberReuseHeaderView.ViewOption) {
        superMemberReuseHeaderView.updateLayoutOption(option: option)
    }
    
    var viewOption: VCSuperMemberReuseHeaderView.ViewOption {
        return superMemberReuseHeaderView.viewOption
    }
}
