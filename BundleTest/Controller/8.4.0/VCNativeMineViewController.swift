//
//  VCNativeMineViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2020/1/15.
//  Copyright © 2020 jianli chen. All rights reserved.
//

import Foundation

// MARK: - <原生 -> 我的>页
class VCNativeMineViewController: VCBaseViewController {
    
    // MARK: - 视图
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let headerView = VCNativeMinePageHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: 200)))
    fileprivate let emptyView = UIView()
    
    // MARK: - 数据
    fileprivate var headerViewHeight: CGFloat = 0
    
    // MARK: - 配置
    override var isNavigationBarTransparent: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    deinit {
        removeAllNCObserver(self)
    }
    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.boundDebug(.green, borderWidth: 2.0)
        headerView.boundDebug(.darkGray, borderWidth: 4.0)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        updateHeaderHeightIfNeeded()
        collectionView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.width.centerX.top.equalToSuperview()
            $0.height.equalTo(headerViewHeight)
        }
        
    }
    
    fileprivate func registerCells() {
        collectionView.register(VCNativeMineGridCardCell.self, forCellWithReuseIdentifier: "VCNativeMineGridCardCell")
        collectionView.register(VCNativeMineListItemCell.self, forCellWithReuseIdentifier: "VCNativeMineListItemCell")
        collectionView.register(VCCollectionCommonEmptyCell.self, forCellWithReuseIdentifier: "VCCollectionCommonEmptyCell")
    }
    
    // MARK: - 逻辑处理
    fileprivate func updateHeaderHeightIfNeeded() {
        let height = headerView.headerViewHeight()
        if height != headerViewHeight {
            headerViewHeight = height
            headerView.height = height
            updateHeaderConstraint()
        }
    }
    
    fileprivate func updateHeaderConstraint() {
        guard headerView.superview != nil else { return }
        var offset: CGFloat = collectionView.contentOffset.y
        offset = offset < 0 ? offset : 0
        let height = headerViewHeight - offset
        print("DEBUG >> offset \(offset), height \(height)")
        headerView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(offset)
            $0.height.equalTo(height)
        }
        offset = collectionView.contentOffset.y
        if offset <= 0 && offset >= -80 {
            headerView.updateCardHeightConstraint(-offset)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension VCNativeMineViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        // let index = indexPath.item
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCNativeMineGridCardCell", for: indexPath)
            cell.boundDebug()
            return cell
        } else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCNativeMineListItemCell", for: indexPath)
            cell.boundDebug(.themeYellow, borderWidth: 1.0)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "VCCollectionCommonEmptyCell", for: indexPath)
    }
}

// MARK: - UICollectionViewFlowLayout
extension VCNativeMineViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderConstraint()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            let itemCount: Int = 4
            let width = (collectionView.width - CGFloat((itemCount - 1) * 8)) / 4
            return CGSize(width: width, height: 90)
        } else if section == 1 {
            return CGSize(width: collectionView.width, height: 48)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: headerViewHeight + 16, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 8
        }
        return 0
    }
    
}

