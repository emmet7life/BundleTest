//
//  VCSuperMemberReuseHeaderView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

// 超级会员专区 - 可重用的头部视图
// 用于：
// 1. VCSuperMemberSupplymentHeaderView
// 2. VCSVIPParticularFlagCollectionViewCell
class VCSuperMemberReuseHeaderView: UIView {
    
    // MARK: - View
    private(set) lazy var leftFlagImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemMediumFont(18.0)
        return label
    }()
    
    private(set) lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemRegularFont(12.0)
        return label
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
        backgroundColor = .white
        
        addSubview(leftFlagImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.text = "标题"
        subTitleLabel.text = "副标题"
        
        updateTextWithOption(label: titleLabel, option: titleOption)
        updateTextWithOption(label: subTitleLabel, option: subTitleOption)
    }
    
    // 配置
    
    // 文本配置
    struct TextOption {
        // style
        var textColor: UIColor
        var textFont: UIFont
        // frame
        var top: CGFloat
        var left: CGFloat
        var right: CGFloat
        var height: CGFloat
    }
    
    // 视图配置
    struct ViewOption {
        var imageName: String? = nil
        var imageOffset: CGFloat = 8.0
        var imageSize: CGSize = CGSize(width: 49, height: 23)
        var imageYOffset: CGFloat = 0// 默认与文本居中，该值是偏移量
        
        var titleOption: TextOption = VCUIStyle.MemberSupplymentHeader.defaultTitleOption1
        var subTitleOption: TextOption = VCUIStyle.MemberSupplymentHeader.defaultSubTitleOption1
        
        var titleText: String? = nil
        var subTitleText: String? = nil
        var backgroundColor: UIColor = .white
    }
    
    private(set) var viewOption: ViewOption = ViewOption()
    private(set) lazy var titleOption: TextOption = { [unowned self] in
        return self.viewOption.titleOption
    }()
    private(set) lazy var subTitleOption: TextOption = { [unowned self] in
        return self.viewOption.subTitleOption
    }()
    
    func updateLayoutOption(option: ViewOption) {
        var titleXOffset: CGFloat = 0
        if let imageName = option.imageName, let image = UIImage(named: imageName) {
            leftFlagImageView.image = image
            leftFlagImageView.size = option.imageSize
            leftFlagImageView.left = option.titleOption.left
            leftFlagImageView.centerY = option.titleOption.top + option.titleOption.height * 0.5 + option.imageYOffset
            titleXOffset = option.imageSize.width + option.imageOffset
        } else {
            leftFlagImageView.image = nil
            leftFlagImageView.size = .zero
        }
        
        if titleOption != option.titleOption {
            titleOption = option.titleOption
            updateTextWithOption(label: titleLabel, option: titleOption, titleXOffset: titleXOffset)
        }
        if subTitleOption != option.subTitleOption {
            subTitleOption = option.subTitleOption
            updateTextWithOption(label: subTitleLabel, option: subTitleOption)
        }
        if titleLabel.text != option.titleText { titleLabel.text = option.titleText }
        if subTitleLabel.text != option.subTitleText { subTitleLabel.text = option.subTitleText }
        if backgroundColor != option.backgroundColor { backgroundColor = option.backgroundColor }
    }
    
    private func updateTextWithOption(label: UILabel, option: TextOption, titleXOffset: CGFloat = 0) {
        label.textColor = option.textColor
        label.font = option.textFont
        label.width = screenWidth - option.left - option.right
        label.height = option.height
        label.top = option.top
        label.left = option.left + titleXOffset
    }
}

private func == (lhs: VCSuperMemberReuseHeaderView.TextOption, rhs: VCSuperMemberReuseHeaderView.TextOption) -> Bool {
    guard lhs.textColor == rhs.textColor else { return false }
    guard lhs.textFont == rhs.textFont else { return false }
    guard lhs.top == rhs.top else { return false }
    guard lhs.left == rhs.left else { return false }
    guard lhs.right == rhs.right else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}

private func != (lhs: VCSuperMemberReuseHeaderView.TextOption, rhs: VCSuperMemberReuseHeaderView.TextOption) -> Bool {
    return !(lhs == rhs)
}
