//
//  VCTopListViewController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/25.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCTopListViewController: UIViewController {
    
    override var isAsChildControllerEmbedInParentController: Bool {
        return true
    }
    
    fileprivate let collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 64.0 + 32.0 * 2)), collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var temp: Int = 10
//        for index in temp ..< 10 {
//            print("A index is \(index)")
//        }
//        for index in temp ..< -1 {
//            print("B index is \(index)")
//        }
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "VCTopListItemCollectionCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: VCTopListItemCollectionCell.identifier)
        collectionView.register(VCTopListCollectionViewSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: VCTopListCollectionViewSupplementaryView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension VCTopListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: VCTopListItemCollectionCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let topListCell = cell as? VCTopListItemCollectionCell {
            topListCell.updateData(with: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VCTopListCollectionViewSupplementaryView.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 45.0)
    }
}

extension VCTopListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = view.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        return CGSize(width: itemWidth, height: 160.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.isPhoneDown5Plus ? 12.0 : 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        if item == 0 {
            let controller = ViewController8.viewController(headMode: .cates)
            navigationController?.pushViewController(controller, animated: true)
        } else if item == 1 {
            let controller = ViewController8.viewController(headMode: [.cates, .end])
            navigationController?.pushViewController(controller, animated: true)
        } else if item == 2 {
            let controller = ViewController8.viewController(headMode: [.pay, .end])
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = ViewController8.viewController(headMode: .all)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

class VCTopListCollectionViewSupplementaryView: UICollectionReusableView {
    
    static let identifier = "VCTopListCollectionViewSupplementaryView"
    
    let textLabel: UILabel = UILabel()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        textLabel.text = "· 榜单更新时间：每周一上午10:00 ·"
        textLabel.textColor = UIColor.colorFF6680
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemRegularFont(11.0)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
