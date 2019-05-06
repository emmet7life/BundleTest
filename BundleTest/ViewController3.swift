//
//  ViewController3.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/22.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import MXParallaxHeader

let kHeaderMinimumHeight: CGFloat = 64.0

class ViewController3: UIViewController {
    
    @IBOutlet weak var scrollView: MXScrollView!
    
    var cellCount: Int = 9
    var interitemSpacing: CGFloat = 0.0
    let headerView = VCFeedInfoHeaderView()
    fileprivate var _pageContainerView = VCPageContainerViewController()
    fileprivate var _veiwController1 = UIViewController()
    fileprivate var _veiwController2 = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 535)
//        view.addSubview(headerView)
        
        guard let collectionView = headerView.feedListBaseView.collectionView else { return }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            let width: CGFloat = 84.0
            let height: CGFloat = 120
            interitemSpacing = ((view.width - (8.0 * 2)) - width * 4.0) / 3.0
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumInteritemSpacing = interitemSpacing
        }
        collectionView.register(UINib(nibName: "VCFeedItemCell", bundle: nil), forCellWithReuseIdentifier: VCFeedItemCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupInnerViewIfNeeded()
        view.layoutIfNeeded()
    }
    
    var kNavBarHeight: CGFloat {
        return kHeaderMinimumHeight + viewSafeAreaInsetsAddtionTop
    }
    var kHeaderHeight: CGFloat {
        return 435.0 + 108.0 + 88.0
    }
    
    fileprivate var _hasAddInnerSubview = false
    fileprivate func setupInnerViewIfNeeded() {
        guard !_hasAddInnerSubview else { return }
        _hasAddInnerSubview = true
        
        scrollView.delegate = self
        scrollView.canCancelContentTouches = true
        scrollView.panGestureRecognizer.cancelsTouchesInView = true
        
        loadHeaderView()
        
        if let navVC = navigationController {
            _pageContainerView.disableScrollPanGestureWhenPopController(vc: navVC)
        }
        
        _pageContainerView.viewControllers = [_veiwController1, _veiwController2]
        
        _pageContainerView.willMove(toParentViewController: self)
        _pageContainerView.view.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        _pageContainerView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.addSubview(_pageContainerView.view)
        _pageContainerView.didMove(toParentViewController: self)
        addChildViewController(_pageContainerView)
        
//        _pageContainerView.delegate = self
        
        
    }
    
    fileprivate func loadHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 535)
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.contentView.clipsToBounds = true
        
        scrollView.parallaxHeader.mode = .fill
        
//        let minimumHeight = kNavBarHeight
        let height = kHeaderHeight
        scrollView.parallaxHeader.minimumHeight = 0.0
        scrollView.parallaxHeader.height = height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard _hasAddInnerSubview else { return }
        var frame = view.frame
        frame.size.height -= viewSafeAreaInsets.bottom + scrollView.parallaxHeader.minimumHeight
        scrollView.contentSize = frame.size
        
        _pageContainerView.view.frame = frame
        _pageContainerView.scrollView.contentSize.height = frame.height
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let height = kHeaderHeight
        
        if scrollView.parallaxHeader.minimumHeight != 0.0 {
            scrollView.parallaxHeader.minimumHeight = 0.0
        }
        
        if scrollView.parallaxHeader.height != height {
            scrollView.parallaxHeader.height = height
        }
    }
}

extension ViewController3: MXScrollViewDelegate {
    func scrollView(_ scrollView: MXScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        if subView == _pageContainerView.scrollView {
            return false
        }
        return true
    }
}

extension ViewController3: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellCount > 0 {
            let modOf8 = cellCount % 8
            return cellCount + (8 - modOf8)
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCFeedItemCell.identifier, for: indexPath)
        if let myCell = cell as? VCFeedItemCell {
            if indexPath.item < cellCount {
                myCell.isHidden = false
            } else {
                myCell.isHidden = true
            }
        }
        return cell
    }
    
}

extension ViewController3: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
}


