//
//  ViewController_SafeArea.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/21.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import SnapKit

class ViewController_SafeArea: UIViewController {
    
    var colors: [UIColor] = [
        .yellow,
        .black,
        .green,
        .blue,
        .red,
        .purple,
        .darkGray,
        .gray,
        .brown,
        .orange
    ]
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBackButton(true)
        
        view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0.00001
        if #available(iOS 11.0, *) {
            layout.sectionInsetReference = .fromSafeArea
        } else {
            // Fallback on earlier versions
        }
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.green
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
//        collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        print("view.layoutMargins \(view.layoutMargins)")
//        let margins = view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
//        ])
        
//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            NSLayoutConstraint.activate([
//                collectionView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0),
//                guide.bottomAnchor.constraintEqualToSystemSpacingBelow(collectionView.bottomAnchor, multiplier: 1.0)
//            ])
//        } else {
//            let standardSpacing: CGFloat = 8.0
//            NSLayoutConstraint.activate([
//                collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
//                bottomLayoutGuide.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: standardSpacing)
//            ])
//        }
        
        // Text
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.backgroundColor = .black
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.textColor = UIColor.white
//        view.addSubview(label)
//
//        if #available(iOS 11.0, *) {
//            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
//            label.frame = CGRect(
//                x: insets.left,
//                y: insets.top,
//                width: view.bounds.size.width - insets.left - insets.right,
//                height: 200)
//        } else {
//            // Fallback on earlier versions
//        }
//
//        let text =
//        """
//                if #available(iOS 11, *) {
//                   let guide = view.safeAreaLayoutGuide
//                   NSLayoutConstraint.activate([
//                    greenView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0),
//                    guide.bottomAnchor.constraintEqualToSystemSpacingBelow(greenView.bottomAnchor, multiplier: 1.0)
//                   ])
//
//                } else {
//                   let standardSpacing: CGFloat = 8.0
//                   NSLayoutConstraint.activate([
//                    greenView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
//                    bottomLayoutGuide.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: standardSpacing)
//                   ])
//                }
//            """
//        label.text = text
//
//        if #available(iOS 11.0, *) {
//            print("additionalSafeAreaInsets \(additionalSafeAreaInsets) | viewDidLoad")
//        } else {
//            // Fallback on earlier versions
//        }
//
//        if #available(iOS 11.0, *) {
////            additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print("viewSafeAreaInsetsDidChange \(view.safeAreaInsets)")
        
        print("additionalSafeAreaInsets \(additionalSafeAreaInsets) | viewSafeAreaInsetsDidChange")
        
//        if #available(iOS 11.0, *) {
//            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
//            label.frame = CGRect(
//                x: insets.left,
//                y: insets.top,
//                width: view.bounds.size.width - insets.left - insets.right,
//                height: 200)
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            print("additionalSafeAreaInsets \(additionalSafeAreaInsets) | viewDidLayoutSubviews")
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            label.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            // Fallback on earlier versions
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
}

extension ViewController_SafeArea: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        if let customCell = cell as? CustomCollectionViewCell {
            let text =
            """
                if #available(iOS 11, *) {
                   let guide = view.safeAreaLayoutGuide
                   NSLayoutConstraint.activate([
                    greenView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0),
                    guide.bottomAnchor.constraintEqualToSystemSpacingBelow(greenView.bottomAnchor, multiplier: 1.0)
                   ])

                } else {
                   let standardSpacing: CGFloat = 8.0
                   NSLayoutConstraint.activate([
                    greenView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                    bottomLayoutGuide.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: standardSpacing)
                   ])
                }
            """
            customCell.label.text = text //"\(indexPath.item + 1)"
        }
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
}

extension ViewController_SafeArea: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if #available(iOS 11.0, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
            if indexPath.item <= 4 {
                return CGSize(width: (collectionView.bounds.size.width - insets.left - insets.right), height: 200)
            }
            return CGSize(width: ((collectionView.bounds.size.width - insets.left - insets.right - 10.5) / 2.0), height: 200)
        } else {
            // Fallback on earlier versions
            return CGSize(width: (collectionView.bounds.size.width) / 3.0, height: 200)
        }
//        return CGSize(width: (collectionView.bounds.size.width), height: 200)
    }

}

class CustomCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if #available(iOS 11.0, *) {
//            label.frame = safeAreaLayoutGuide.layoutFrame
//            print("safeAreaLayoutGuide.layoutFrame is \(safeAreaLayoutGuide.layoutFrame)")
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
}
