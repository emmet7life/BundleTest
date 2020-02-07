//
//  VCSuperMemberZoneViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// 超级会员专区
class VCSuperMemberZoneViewController: VCBaseViewController {
    
    // MARK: - View
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        title = "超级会员专区"
        configNavBackButton()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 头尾
        collectionView.register(VCSuperMemberSupplymentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VCSuperMemberSupplymentHeaderView.identifier)
        collectionView.register(VCSuperMemberSupplymentFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: VCSuperMemberSupplymentFooterView.identifier)
        // 容错的空头尾UICollectionReusableView
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        
        // VIP独享作品
        collectionView.register(VCMemberParticularStyle1CollectionViewCell.self, forCellWithReuseIdentifier: VCMemberParticularStyle1CollectionViewCell.identifier)
        // 安利墙
        collectionView.register(VCMemberBrainwashRectCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberBrainwashRectCollectionViewCell.identifier)
        // 会员限免 & 超人气作品抢先看
        collectionView.register(VCMemberLimitFreeCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberLimitFreeCollectionViewCell.identifier)
        // 会员全场7折
        collectionView.register(VCMemberDiscountCollectionViewCell.self, forCellWithReuseIdentifier: VCMemberDiscountCollectionViewCell.identifier)
        // 容错的空Cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension VCSuperMemberZoneViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {// VIP专属
            return 1
        } else if section == 1 {// 安利墙
            return 1
        } else if section == 2 {// 会员限免
            return 6
        } else if section == 3 {// 会员全场7折
            return 1
        } else if section == 4 {// 超人气作品抢先看
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {// VIP专属
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberParticularStyle1CollectionViewCell.identifier, for: indexPath)
        } else if section == 1 {// 安利墙
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberBrainwashRectCollectionViewCell.identifier, for: indexPath)
        } else if section == 2 || section == 4 {// 会员限免 & 超人气作品抢先看
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberLimitFreeCollectionViewCell.identifier, for: indexPath)
        } else if section == 3 {// 会员全场7折
            return collectionView.dequeueReusableCell(withReuseIdentifier: VCMemberDiscountCollectionViewCell.identifier, for: indexPath)
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
                if section == 0 {// VIP专属
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption1
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption1
                    option.titleText = "VIP独享作品"
                    option.subTitleText = "我是副标题"
                    option.backgroundColor = .gray
                    option.imageName = nil
                    header.updateLayoutOption(option: option)
                } else if section == 1 {// 安利墙
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "安利墙"
                    option.subTitleText = "我是副标题"
                    option.backgroundColor = .white
                    option.imageName = nil
                    header.updateLayoutOption(option: option)
                } else if section == 2 {// 会员限免
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "会员限免"
                    option.subTitleText = "我是副标题"
                    option.backgroundColor = .white
                    option.imageName = nil
                    header.updateLayoutOption(option: option)
                } else if section == 3 {// 会员全场7折
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "会员全场7折"
                    option.subTitleText = "我是副标题"
                    option.backgroundColor = .white
                    option.imageName = nil
                    header.updateLayoutOption(option: option)
                }  else if section == 4 {// 超人气作品抢先看
                    var option = header.viewOption
                    option.titleOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption2
                    option.subTitleOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption2
                    option.titleText = "超人气作品抢先看"
                    option.subTitleText = "我是副标题"
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
        if section == 0 {// VIP专属
            return VCMemberParticularStyle1CollectionViewCell.cellItemSize
        } else if section == 1 {// 安利墙
            return CGSize(width: screenWidth, height: 203)
        } else if section == 2 || section == 4 {// 会员限免 & 超人气作品抢先看
            let itemWidth: CGFloat = ((screenWidth - (16.0 * 2) - (8.0 * 2)) / 3) - 1.0
            let itemHeight: CGFloat = itemWidth * 146.67 / 110 + 60.0
            return CGSize(width: itemWidth, height: itemHeight)
        } else if section == 3 {// 会员全场7折
            let itemWidth: CGFloat = screenWidth - 16.0 * 2
            let itemHeight: CGFloat = itemWidth * 186 / 343
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {// VIP专属
            return CGSize(width: 0, height: 0.01)
        } else if section == 1 {// 安利墙
            return CGSize(width: screenWidth, height: 70)
        } else if section == 2 || section == 4 {// 会员限免 & 超人气作品抢先看
            return CGSize(width: screenWidth, height: 70)
        }
        return CGSize(width: 0, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWidth, height: 66)
        }
        return CGSize(width: screenWidth, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 || section == 4 {// 会员限免 & 超人气作品抢先看
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if section == 3 {// 会员全场7折
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 || section == 4 {
            return 24
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 || section == 4 {
            return 8.0
        }
        return 0
    }
    
}
