//
//  VCMedalButton.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/4.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

// MARK: - 拓展自UILabel实现文字描边效果
@IBDesignable public class VCOutlinedText: UILabel {
    
    private var _outlineColor: UIColor?
    private var _outlineWidth: CGFloat?
    
    @IBInspectable var outlineColor: UIColor {
        get { return _outlineColor ?? UIColor.clear }
        set { _outlineColor = newValue }
    }
    
    @IBInspectable var outlineWidth: CGFloat {
        get { return _outlineWidth ?? 0 }
        set { _outlineWidth = newValue }
    }
    
    override public func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor
        
        let c = UIGraphicsGetCurrentContext()
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textColor = outlineColor
        super.drawText(in:rect)
        
        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)
        
        self.shadowOffset = shadowOffset
    }
}

// MARK: - 勋章🎖等级 组件
@IBDesignable public class VCMedalLevelButton: UIButton {
    
    // MARK: - 布局参数
    public typealias MedalButtonLayoutInfo =
        (
        medalButtonSize: CGSize,// Button的Size
        iconSize: CGSize,// 图标的Size
        labelOffset: CGPoint, labelSize: CGSize, labelFont: UIFont, labelColor: UIColor, labelGrayColor: UIColor, labelAlignment: NSTextAlignment,// 等级Label的位置和字体/颜色等参数
        outlineWidth: CGFloat?, outlineColor: UIColor?// 等级Label描边参数
    )
    
    // MARK: - 样式：支持内置的small和big，以及自定义参数
    public enum MedalButtonStyle {
        case small
        case big
        case custom(MedalButtonLayoutInfo)
        
        // 布局参数
        var layoutInfo: MedalButtonLayoutInfo {
            switch self {
//            case .small:
//                return (CGSize(width: 40, height: 24), CGSize(width: 22, height: 20), CGPoint(x: 13, y: 6), CGSize(width: 27, height: 18), UIFont.boldSystemFont(ofSize: 12), UIColor.white, UIColor.white, NSTextAlignment.left, 4.0, UIColor.colorWithHexRGBA(0xFFA165))
//            case .big:
//                return (CGSize(width: 49, height: 30), CGSize(width: 28, height: 26), CGPoint(x: 14, y: 10), CGSize(width: 35, height: 20), UIFont.boldSystemFont(ofSize: 13), UIColor.white, UIColor.white, NSTextAlignment.left, 5.0, UIColor.colorWithHexRGBA(0xFFA165))
//            case .custom(let layoutInfo):
//                return layoutInfo
            case .small:
                return (
                    CGSize(width: 30, height: 15),// medalButtonSize
                    CGSize(width: 14, height: 14),// iconSize
                    CGPoint(x: 9, y: 5),// labelOffset
                    CGSize(width: 20, height: 10),// labelSize
                    UIFont.boldSystemFont(ofSize: 8),// labelFont
                    UIColor.white,// labelColor
                    UIColor.white,// labelGrayColor
                    NSTextAlignment.left,// labelAlignment
                    2.5, UIColor.colorWithHexRGBA(0xFFA165))// outlineWidth、outlineColor
            case .big:
                return (
                    CGSize(width: 44, height: 23),
                    CGSize(width: 20, height: 20),
                    CGPoint(x: 13, y: 6),
                    CGSize(width: 30, height: 16),
                    UIFont.boldSystemFont(ofSize: 12),
                    UIColor.white,
                    UIColor.white,
                    NSTextAlignment.left,
                    3.5,
                    UIColor.colorWithHexRGBA(0xFFA165)
                )
            case .custom(let layoutInfo):
                return layoutInfo
            }
        }
    }
    
    // MARK: - Style
    private(set) var style: MedalButtonStyle = .small
    
    // MARK: - View
    private var icon: UIImageView = UIImageView()
    private var label: VCOutlinedText = VCOutlinedText()
    
    // MARK: - Private
    private var _isDidInitialized: Bool = false
    private var _medalLevel: UInt = 0
    private var _medalIcon: String = "ic_medal_level_icon"
    private var _medalGrayIcon: String = "ic_medal_level_gray_icon"
    
    init(style: MedalButtonStyle = .small) {
        super.init(frame: CGRect(origin: .zero, size: style.layoutInfo.medalButtonSize))
        self.style = style
        _didInitialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _didInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _didInitialize()
    }
    
    private func _didInitialize() {
        guard !_isDidInitialized else { return }
        _isDidInitialized = true
        
        backgroundColor = .clear
        
        let layoutInfo = style.layoutInfo
        
        icon.contentMode = .scaleAspectFill
        
        label.textAlignment = layoutInfo.labelAlignment
        label.font = layoutInfo.labelFont
        label.outlineWidth = layoutInfo.outlineWidth ?? 0
        
        addSubview(icon)
        addSubview(label)
        
        _layout(with: layoutInfo)
        _updateContentIfNeeded()
    }
    
    private func _layout(with layoutInfo: MedalButtonLayoutInfo) {
        frame.size = layoutInfo.medalButtonSize
        icon.frame = CGRect(origin: CGPoint.zero, size: layoutInfo.iconSize)
        label.frame = CGRect(origin: layoutInfo.labelOffset, size: layoutInfo.labelSize)
    }
    
    private func _updateContentIfNeeded() {
        // 0 级时，是灰色样式
        let layoutInfo = style.layoutInfo
        if _medalLevel <= 0 {
            label.textColor = layoutInfo.labelGrayColor
            label.outlineColor = UIColor.colorWithHexRGBA(0x999999)
            icon.image = UIImage(named: _medalGrayIcon)
        } else {
            label.textColor = layoutInfo.labelColor
            label.outlineColor = layoutInfo.outlineColor ?? .clear
            icon.image = UIImage(named: _medalIcon)
        }
        
        switch style {
        case .small: label.text = " \(_medalLevel)"
        case .big: label.text = " \(_medalLevel)"
        default: label.text = "\(_medalLevel)"
        }
        label.setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Override
    override public func layoutSubviews() {
        super.layoutSubviews()
        if !_isDidInitialized {
            _didInitialize()
        }
        
        let layoutInfo = style.layoutInfo
        if frame.size != layoutInfo.medalButtonSize {
            _layout(with: layoutInfo)
        }
    }
    
    // 重写setTitle、setImage使得UIButton的通用设置无效
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(nil, for: state)
    }
    
    override public func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(nil, for: state)
    }
    
    // MARK: - 对外提供的API
    @IBInspectable var medalLevel: UInt {
        get { return _medalLevel }
        set {
            if _medalLevel != newValue {
                _medalLevel = newValue
                _updateContentIfNeeded()
            }
        }
    }
    
    @IBInspectable var medalIcon: String {
        get { return _medalIcon }
        set {
            if _medalIcon != newValue {
                _medalIcon = newValue
                _updateContentIfNeeded()
            }
        }
    }
    
    @IBInspectable var medalGrayIcon: String {
        get { return _medalGrayIcon }
        set {
            if _medalGrayIcon != newValue {
                _medalGrayIcon = newValue
                _updateContentIfNeeded()
            }
        }
    }
    
    public func updateStyle(with style: VCMedalLevelButton.MedalButtonStyle) {
        self.style = style
        _isDidInitialized = false
        _didInitialize()
        setNeedsLayout()
    }
}
