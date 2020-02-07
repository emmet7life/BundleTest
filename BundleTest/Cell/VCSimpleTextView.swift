//
//  VCSimpleTextView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/8/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation
import SnapKit
import YYCategories

class VCSimpleTextView: UIView {
    
    // MARK: - View
    private let contentView: UIView = UIView()
    let textLabel: UILabel = UILabel()
    let iconImage: UIImageView = UIImageView()
    private let iconButton: UIButton = UIButton(type: .custom)
    
    // MARK: - Constraint
    private var textLabelTrailingToIconButtonLeadingConstraint: Constraint? = nil
    private var iconImageWidthConstraint: Constraint? = nil
    private var iconImageHeightConstraint: Constraint? = nil
    
    // MARK: - ICON点击事件回调
    var onIconTappedBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .white
        textLabel.font = UIFont.systemRegularFont(12)
        textLabel.textColor = UIColor.mainColor
        
        iconImage.contentMode = .scaleAspectFit
        
        addSubview(contentView)
        contentView.addSubview(textLabel)
        contentView.addSubview(iconImage)
        iconImage.addSubview(iconButton)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImage.snp.makeConstraints {
            $0.trailing.equalTo(-18)
            $0.centerY.equalToSuperview()
            self.iconImageWidthConstraint = $0.width.equalTo(0).constraint
            self.iconImageHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(18)
            $0.centerY.equalToSuperview()
            self.textLabelTrailingToIconButtonLeadingConstraint = $0.trailing.equalTo(iconImage.snp.leading).offset(-8).constraint
        }
        
        iconButton.addBlock(for: .touchUpInside)
        { [weak self] (_) in
            self?.onIconTappedBlock?()
        }
    }
    
    // 纯文本 & 图名称
    func setText(with text: String? = nil, imageName: String? = nil) {
        setAttributedText(with: NSAttributedString(string: text ?? ""), imageName: imageName)
    }
    
    // 纯文本 & UIImage图对象
    func setText(with text: String? = nil, image: UIImage? = nil) {
        setAttributedText(with: NSAttributedString(string: text ?? ""), image: image)
    }
    
    // 富文本 & 图名称
    func setAttributedText(with attrText: NSAttributedString? = nil, imageName: String? = nil) {
        setAttributedText(with: attrText, image: UIImage(named: imageName ?? ""))
    }
    
    // 富文本 & UIImage图对象
    func setAttributedText(with attributedText: NSAttributedString? = nil, image: UIImage? = nil) {
        if let _image = image, _image.size.width > 0, _image.size.height > 0 {
            textLabelTrailingToIconButtonLeadingConstraint?.update(offset: -8)
            iconImage.image = _image
        } else {
            textLabelTrailingToIconButtonLeadingConstraint?.update(offset: 0)
            iconImage.image = nil
        }
        iconImage.sizeToFit()
        let size = iconImage.size
        if size.width < 44 || size.height < 44 {
            // 如果ICON是可触摸的，则要让Button的size足够大
            iconButton.size = CGSize(width: max(44, size.width), height: max(44, size.height))
        } else {
            iconButton.size = size
        }
        iconImageWidthConstraint?.update(offset: size.width)
        iconImageHeightConstraint?.update(offset: size.height)
        textLabel.attributedText = attributedText
        layoutIfNeeded()
    }
}
