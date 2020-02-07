//
//  VCMemberBenefitsViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/11.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import YYCategories

// 会员权益页
class VCMemberBenefitsViewController: VCBaseViewController {

    // MARK: - View
    private lazy var cyclePageView: TYCyclePagerView = {
        let view = TYCyclePagerView(frame: CGRect.zero)
        view.autoScrollInterval = 0
        view.isInfiniteLoop = true
        view.register(VCMemberBenefitsCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberBenefitsCollectionViewCell.identifier)
        return view
    }()
    
    private lazy var cyclePageControl: TYPageControl = {
        let view = TYPageControl(frame: CGRect.zero)
        view.pageIndicatorSize = CGSize(width: 8, height: 8)
        view.pageIndicatorTintColor = UIColor.colorWithHexRGBA(0xDCDCDC)
        view.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        view.currentPageIndicatorTintColor = UIColor.colorWithHexRGBA(0xFFDEA2)
        view.pageIndicatorSpaing = 7.0
        return view
    }()
    
    private(set) lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("立即续费", for: .normal)
        button.setTitleColor(UIColor.colorWithHexRGBA(0xC98000), for: .normal)
        button.titleLabel?.font = UIFont.systemMediumFont(16.0)
        button.backgroundColor = UIColor.colorWithHexRGBA(0xFFDDA1)
        button.setViewCorner(view: button, cornerRadius: 25.0)
        button.isScaleDownEffectEnable = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "会员权益说明"
        view.backgroundColor = UIColor.colorWithHexRGBA(0xF7F9FA)
        configNavBackButton()
        
        view.addSubview(payButton)
        payButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(cyclePageControl)
        cyclePageControl.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(payButton.snp.top).offset(-23)
            make.height.equalTo(10)
        }
        
        view.addSubview(cyclePageView)
        cyclePageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cyclePageControl.snp.top).offset(20)
        }
        
        cyclePageView.dataSource = self
        cyclePageView.delegate = self
        
        payButton.addBlock(for: UIControl.Event.touchUpInside) { [weak self] (_) in
            guard let strongSelf = self else { return }
            let controller = VCSuperMemberZoneViewController()
            strongSelf.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension VCMemberBenefitsViewController: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    // MARK: TYCyclePagerViewDataSource
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        cyclePageControl.numberOfPages = 8
        return 8
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: VCMemberBenefitsCollectionViewCell.identifier, for: index)
//        cell.backgroundColor = self.datas[index]
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: screenWidth - 28 * 2, height: view.height - 22 - 121)
        layout.itemSpacing = 13
        layout.minimumAlpha = 0.9
        layout.minimumScale = 0.9
        layout.layoutType = .linear
        layout.itemHorizontalCenter = true
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.cyclePageControl.currentPage = toIndex;
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        let controller = VCMineSuperMemberViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
