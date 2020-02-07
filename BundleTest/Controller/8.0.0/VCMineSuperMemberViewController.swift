//
//  VCMineSuperMemberViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 我的超级会员
class VCMineSuperMemberViewController: VCBaseViewController {

    // MARK: - View
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override var isNavigationBarTransparent: Bool {
        return true
    }
    
    private var viewSafeAreaInsetsBottom: CGFloat {
        return AppContext.shared.viewSafeAreaCompat.bottom
    }
    
    private var bottomView: UIView = UIView()
    private var bottomButton: UIButton = UIButton(type: .custom)
    private lazy var bottomBackgroundLayer: CALayer = {
        let frame = CGRect(x: 0, y: 0, width: screenWidth - 16 * 2, height: 50)
        return CALayer.createGradualColorLayer(color: [UIColor.colorWithHexRGBA(0xFDF1D5).cgColor, UIColor.colorWithHexRGBA(0xFFDDA1).cgColor],
                                               startPoint: CGPoint(x: 0, y: 0.5),
                                               endPoint: CGPoint(x: 1.0, y: 0.5),
                                               locations: [0.5], frame: frame)
    }()
    fileprivate let bottomViewHeight: CGFloat = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .gray
        
        title = "超级会员专区"
        configNavBackButton()
        
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomViewHeight + viewSafeAreaInsetsBottom)
        }
        
        bottomView.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(7)
            make.height.equalTo(50)
        }
        bottomButton.layer.masksToBounds = true
        bottomButton.layer.cornerRadius = 25.0
        bottomButton.isScaleDownEffectEnable = true
        bottomButton.backgroundColor = .clear
        bottomButton.titleLabel?.font = UIFont.systemMediumFont(18)
        bottomButton.setTitleColor(UIColor.colorWithHexRGBA(0xC98000), for: .normal)
        
        bottomBackgroundLayer.cornerRadius = 25.0
        bottomBackgroundLayer.masksToBounds = true
        bottomBackgroundLayer.frame = CGRect(x: 0, y: 0, width: screenWidth - 16 * 2, height: 50)
        bottomButton.layer.insertSublayer(bottomBackgroundLayer, at: 0)
        
        // 头尾
        collectionView.register(VCSuperMemberSupplymentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VCSuperMemberSupplymentHeaderView.identifier)
        collectionView.register(VCSuperMemberSupplymentFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: VCSuperMemberSupplymentFooterView.identifier)
        // 容错的空头尾UICollectionReusableView
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        
        // 会员信息
        collectionView.register(VCMineSuperMemberCardViewCell.self, forCellWithReuseIdentifier: VCMineSuperMemberCardViewCell.identifier)
        // VIP独享作品
        collectionView.register(VCMemberParticularStyle2CollectionViewCell.self, forCellWithReuseIdentifier: VCMemberParticularStyle2CollectionViewCell.identifier)
        // 会员福利
        collectionView.register(VCMemberBenefitsGiftRectCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberBenefitsGiftRectCollectionViewCell.identifier)
        // 会员限免 & 超人气作品抢先看
        collectionView.register(VCMemberLimitFreeCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberLimitFreeCollectionViewCell.identifier)
        // 会员全场7折
        collectionView.register(VCMemberDiscountCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberDiscountCollectionViewCell.identifier)
        // VIP专属标识
        collectionView.register(VCSVIPParticularFlagCollectionViewCell.self, forCellWithReuseIdentifier: VCSVIPParticularFlagCollectionViewCell.identifier)
        // 容错的空Cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension VCMineSuperMemberViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {// 会员信息
            return 1
        } else if section == 1 {// VIP独享作品
            return 1
        } else if section == 2 {// 会员福利
            return 1
        } else if section == 3 {// 会员全场7折
            return 1
        } else if section == 4 {// 会员限免
            return 6
        } else if section == 5 {// 超人气作品抢先看
            return 6
        } else if section == 6 {// 专属标识
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {// 会员信息
            return  collectionView.dequeueReusableCell(withReuseIdentifier: VCMineSuperMemberCardViewCell.identifier, for: indexPath)
        } else if section == 1 {// VIP独享作品
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberParticularStyle2CollectionViewCell.identifier, for: indexPath)
        } else if section == 2 {// 会员福利
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberBenefitsGiftRectCollectionViewCell.identifier, for: indexPath)
        } else if section == 3 {// 会员全场7折
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberDiscountCollectionViewCell.identifier, for: indexPath)
        } else if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberLimitFreeCollectionViewCell.identifier, for: indexPath)
        } else if section == 6 {// 专属标识
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCSVIPParticularFlagCollectionViewCell.identifier, for: indexPath)
        }
        // 容错Cell
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if kind == UICollectionView.elementKindSectionHeader {
            // 头部
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VCSuperMemberSupplymentHeaderView.identifier, for: indexPath)
            if let header = headerView as? VCSuperMemberSupplymentHeaderView {
                
                if section == 0 {// 会员信息
                    
                } else if section == 1 {// VIP独享作品
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "SVIP独享作品"
                    option.subTitleText = "我是副标题"
                    option.imageName = "levelBG"
                    option.backgroundColor = .white
                    header.updateLayoutOption(option: option)
                } else if section == 2 {// 会员福利
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "SVIP会员福利"
                    option.subTitleText = "我是副标题"
                    option.imageName = "levelBG"
                    option.backgroundColor = .white
                    header.updateLayoutOption(option: option)
                } else if section == 3 {// 会员全场7折
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "SVIP全场7折"
                    option.subTitleText = "我是副标题"
                    option.imageName = "levelBG"
                    option.backgroundColor = .white
                    header.updateLayoutOption(option: option)
                } else if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "会员限免 & 超人气作品抢先看"
                    option.subTitleText = "我是副标题"
                    option.imageName = "levelBG"
                    option.backgroundColor = .white
                    header.updateLayoutOption(option: option)
                } else if section == 6 {// 专属标识
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = nil
                    option.subTitleText = nil
                    option.backgroundColor = .white
                    option.imageName = nil
                    header.updateLayoutOption(option: option)
                }
                
            }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            
            // 尾部
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VCSuperMemberSupplymentFooterView.identifier, for: indexPath)
            if let footer = footerView as? VCSuperMemberSupplymentFooterView {
                footer.updateLayoutStyle(with: .switchLeftMoreRight)
            }
            return footerView
            
        }
        
        // 容错UICollectionReusableView
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let section = indexPath.section
        if section == 0 {// 会员信息
            return CGSize(width: screenWidth, height: 284)
        } else if section == 1 {// VIP专属
            return VCMemberParticularStyle2CollectionViewCell.cellItemSize
        } else if section == 2 {// 会员福利
            return VCMemberBenefitsGiftRectCollectionViewCell.cellItemSize
        } else if section == 3 {// 会员全场7折
            let itemWidth: CGFloat = screenWidth - 16.0 * 2
            let itemHeight: CGFloat = itemWidth * 186 / 343
            return CGSize(width: itemWidth, height: itemHeight)
        } else if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
            let itemWidth: CGFloat = ((screenWidth - (16.0 * 2) - (8.0 * 2)) / 3) - 1.0
            let itemHeight: CGFloat = itemWidth * 146.67 / 110 + 60.0
            return CGSize(width: itemWidth, height: itemHeight)
        } else if section == 6 {// 专属标识
            let itemWidth: CGFloat = screenWidth
            let itemHeight: CGFloat = itemWidth * 416 / 375
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {// 会员信息
            return CGSize(width: 0, height: 0.01)
        } else if section == 1 {// VIP专属
            return CGSize(width: 0, height: 0.01)
        } else if section == 2 {// 会员福利
            return CGSize(width: 0, height: 0.01)
        } else if section == 3 {// 全场7折
            return CGSize(width: 0, height: 0.01)
        } else if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
            return CGSize(width: screenWidth, height: 70)
        } else if section == 6 {// 专属标识
            return CGSize(width: 0, height: 0.01)
        }
        return CGSize(width: 0, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {// 会员信息
            return CGSize(width: 0, height: 0.01)
        } else if section == 1 {// VIP专属
            return CGSize(width: 0, height: 112)
        } else if section == 2 {// 会员福利
            return CGSize(width: 0, height: 112)
        } else if section == 3 {// 全场7折
            return CGSize(width: 0, height: 112)
        } else if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
            return CGSize(width: screenWidth, height: 112)
        } else if section == 6 {// 专属标识
            return CGSize(width: 0, height: 64)
        }
        return CGSize(width: 0, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 4 || section == 5 {// 会员限免 & 超人气作品抢先看
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if section == 3 {// 会员全场7折
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if section == 2 {// 会员福利
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 4 || section == 5 {
            return 24
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 4 || section == 5 {
            return 8.0
        }
        return 0
    }
    
}
