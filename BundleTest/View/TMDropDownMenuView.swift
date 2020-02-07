//
//  TMDropDownMenuView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/9/19.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation
import SnapKit

// MARK: - MENU默认配置
private let kMenuNormalTextColor = UIColor.assitantColor
private let kMenuNormalTextFont = UIFont.systemRegularFont(14.0)
private let kMenuNormalBackgroundColor: UIColor = .clear

private let kMenuSelectedTextColor = UIColor.colorF86A83
private let kMenuSelectedTextFont = UIFont.systemRegularFont(14.0)
private let kMenuSelectedBackgroundColor = UIColor.clear

// 下拉菜单组件
class TMDropDownMenuView: UIView {
    
    // 配置参数
    struct TMDropDownMenuOption {
        
        // 非当前选中菜单项样式：字体颜色，字体，背景
        var menuNormalTextColor: UIColor = kMenuNormalTextColor
        var menuNormalTextFont: UIFont = kMenuNormalTextFont
        var menuNormalBackgroundColor: UIColor = kMenuNormalBackgroundColor
        
        // 当前选中菜单项样式：字体颜色，字体，背景
        var menuSelectedTextColor: UIColor = kMenuSelectedTextColor
        var menuSelectedTextFont: UIFont = kMenuSelectedTextFont
        var menuSelectedBackgroundColor: UIColor = kMenuSelectedBackgroundColor
        
        // 默认选中菜单项索引
        var selectedMenuIndex: Int = 0
        
        var menuContainerEdgeInsets: UIEdgeInsets = .zero
        var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .left
        var itemHeight: CGFloat = 44
        var maxContentViewHeight: CGFloat = 300
        
        var dimmingAlpha: CGFloat = 0.36
        var animationDuration: TimeInterval = 0.26
        
        var backgroundViewCornerRadius: CGFloat = 8.0
        var viewBackgroundColor: UIColor = .white
        var viewBackgroundImage: UIImage? = UIImage(named: "pop_menu_bg_ic")
        var viewBackgroundEdgeInsets: UIEdgeInsets = .zero
    }
    
    private(set) var menus: [String] = []
    private(set) var option = TMDropDownMenuOption()
    private(set) lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "idtMenuItemCell")
        return collectionView
    }()
    private let contentView = UIView()
    private let dimmingView = UIView()
    private var tapGesture: UITapGestureRecognizer? = nil
    
    typealias TMDropDownMenuCallback = (String, Int) -> Void
    var menuActionCallback: TMDropDownMenuCallback? = nil
    private var contentViewTopConstraint: Constraint?
    private var contentViewHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    convenience init(menus: [String], option: TMDropDownMenuOption, menuActionCallback: @escaping TMDropDownMenuCallback) {
        self.init(frame: .zero)
        self.menus = menus
        self.menuActionCallback = menuActionCallback
        updateOption(option)
    }
    
    func show(_ isWithAlphaAnim: Bool = true, completion: (() -> Void)? = nil) {
        startDropDownAnimation(option.menuContainerEdgeInsets.top, completion: completion)
        if isWithAlphaAnim || dimmingView.alpha <= 0 {
            startDimmingAnimation(option.dimmingAlpha)
        }
    }
    
    func dismiss(_ isWithAlphaAnim: Bool = true, completion: (() -> Void)? = nil) {
        startDropDownAnimation(-contentViewHeight, completion: completion)
        if isWithAlphaAnim {
            startDimmingAnimation(0)
        }
    }
    
    func exchangeMenus(_ menus: [String], menuIndex: Int = 0) {
        if menus.isEmpty { return }
        dismiss(false) { [weak self] in
            guard let SELF = self else { return }
            SELF.menus = menus
            SELF.option.selectedMenuIndex = menuIndex
            SELF.collectionView.reloadData()
            SELF.calculateContentViewHeightAndMakeConstraint()
            SELF.layoutIfNeeded()
            if menuIndex < menus.count {
                SELF.collectionView.scrollToItem(at: IndexPath(item: menuIndex, section: 0), at: .top, animated: false)
            }
            SELF.show(false)
        }
    }
    
    private func startDropDownAnimation(_ offset: CGFloat, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: option.animationDuration, animations: {
            self.contentViewTopConstraint?.update(offset: offset)
            self.layoutIfNeeded()
        }) { (finishFlag) in
            completion?()
        }
    }
    
    private func startDimmingAnimation(_ alpha: CGFloat, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: option.animationDuration, animations: {
            self.dimmingView.alpha = alpha
            self.layoutIfNeeded()
        }) { (finishFlag) in
            completion?()
        }
    }
    
    func updateOption(_ option: TMDropDownMenuOption) {
        self.option = option
        didInitialize()
    }
    
    func didInitialize() {
        clipsToBounds = true
        removeAllSubviews()
        contentView.removeAllSubviews()
        
        backgroundColor = .clear
        dimmingView.isUserInteractionEnabled = true
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        dimmingView.alpha = 0.0
        addSubview(dimmingView)
        dimmingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if tapGesture == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(chromeTapped(_:)))
            gesture.cancelsTouchesInView = false
            dimmingView.addGestureRecognizer(gesture)
            tapGesture = gesture
        }
        
        
        contentView.clipsToBounds = true
        addSubview(contentView)
        calculateContentViewHeightAndMakeConstraint()
        
        // 创建背景
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleToFill
        if let backgroundImage = option.viewBackgroundImage {
            bgImageView.image = backgroundImage
        } else {
            bgImageView.backgroundColor = option.viewBackgroundColor
            if option.backgroundViewCornerRadius > 0 {
                bgImageView.layer.masksToBounds = true
                bgImageView.layer.cornerRadius = option.backgroundViewCornerRadius
            }
        }
        
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(-option.viewBackgroundEdgeInsets.top)
            make.leading.equalTo(contentView).offset(-option.viewBackgroundEdgeInsets.left)
            make.bottom.equalTo(contentView).offset(option.viewBackgroundEdgeInsets.bottom)
            make.trailing.equalTo(contentView).offset(option.viewBackgroundEdgeInsets.right)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.reloadData()
    }
    
    private func calculateContentViewHeightAndMakeConstraint() {
        let totalMenuHeight = CGFloat(menus.count) * option.itemHeight + option.menuContainerEdgeInsets.vertical
        contentViewHeight = min(option.maxContentViewHeight, totalMenuHeight)
        
        contentView.snp.removeConstraints()
        contentView.snp.makeConstraints { (make) in
            self.contentViewTopConstraint = make.top.equalToSuperview().offset(-self.contentViewHeight).constraint
            make.left.equalToSuperview().offset(option.menuContainerEdgeInsets.left)
            make.right.equalToSuperview().offset(-option.menuContainerEdgeInsets.right)
            make.height.equalTo(self.contentViewHeight)
        }
    }
    
    @objc private func chromeTapped(_ sender: UITapGestureRecognizer) {
//        if !dimmingView.frame.contains(sender.location(in: contentView)) {
//        }
        dismiss()
    }
    
}

extension TMDropDownMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let button = cell.contentView.viewWithTag(1000) as? UIButton {
            button.setTitle(menus[index, true], for: .normal)
            if index == option.selectedMenuIndex {
                button.isSelected = true
                button.titleLabel?.font = option.menuSelectedTextFont
            } else {
                button.isSelected = false
                button.titleLabel?.font = option.menuNormalTextFont
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: option.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuIndex = indexPath.item
        menuActionCallback?(menus[menuIndex], menuIndex)
    }
    
}

extension TMDropDownMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idtMenuItemCell", for: indexPath)
        if cell.contentView.viewWithTag(1000) is UIButton {
            
        } else {
            let button = UIButton(type: .custom)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.yellow.cgColor
            button.isUserInteractionEnabled = false
            button.contentHorizontalAlignment = option.contentHorizontalAlignment
            button.setTitleColor(option.menuNormalTextColor, for: .normal)
            button.setTitleColor(option.menuSelectedTextColor, for: .selected)
            button.setTitleColor(option.menuSelectedTextColor, for: .highlighted)
            button.setBackgroundImage(UIImage.imageFromColor(option.menuNormalBackgroundColor), for: .normal)
            button.setBackgroundImage(UIImage.imageFromColor(option.menuSelectedBackgroundColor), for: .selected)
            button.setBackgroundImage(UIImage.imageFromColor(option.menuSelectedBackgroundColor), for: .highlighted)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            button.tag = 1000
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        return cell
    }
}
