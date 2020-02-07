//
//  TMToastView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/10/16.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import SnapKit

class TMToastView: UIView {
    
    struct Option {
        // View Style
        var paddingEdge: UIEdgeInsets = .zero
        var marginEdge: UIEdgeInsets = .zero
        var numberOfLines: Int = 0
        var textAlignment: NSTextAlignment = .center
        var textColor: UIColor = UIColor.white
        var textFont: UIFont = UIFont.systemMediumFont(14)
        var backgroundImage: UIImage? = nil
        var backgroundColor: UIColor = UIColor.colorFF6680.withAlphaComponent(0.9)
        // Animate Style
        var showDuration: TimeInterval = 0.36
        var stayDuration: TimeInterval = 0.5
        var dismissDuration: TimeInterval = 0.25
    }
    
    // MARK: - Data
    private(set) var option = Option()
    
    // MARK: - View
    private let contentView = UIView()
    private let backgroundImageView = UIImageView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _didInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _didInitialize()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func _didInitialize() {
        addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(textLabel)
        _setupSubviewsWithOptionChanged()
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func _setupSubviewsWithOptionChanged() {
        textLabel.numberOfLines = option.numberOfLines
        textLabel.textAlignment = option.textAlignment
        textLabel.textColor = option.textColor
        textLabel.font = option.textFont
        if let image = option.backgroundImage {
            backgroundImageView.image = image
        } else {
            backgroundImageView.backgroundColor = option.backgroundColor
        }
        let top: CGFloat
        if #available(iOS 11.0, *) {
            top = safeAreaInsets.top
        } else {
            top = 0
        }
        let paddingEdge = UIEdgeInsets(top: option.paddingEdge.top + top,
                                       left: option.paddingEdge.left,
                                       bottom: option.paddingEdge.bottom,
                                       right: option.paddingEdge.right)
        textLabel.snp.remakeConstraints { (make) in
            make.edges.equalTo(paddingEdge)
        }
        contentView.snp.remakeConstraints { (make) in
            make.edges.equalTo(option.marginEdge)
        }
    }
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        let top = safeAreaInsets.top
        let paddingEdge = UIEdgeInsets(top: option.paddingEdge.top + top,
                                       left: option.paddingEdge.left,
                                       bottom: option.paddingEdge.bottom,
                                       right: option.paddingEdge.right)
        textLabel.snp.remakeConstraints { (make) in
            make.edges.equalTo(paddingEdge)
        }
    }
    
    func updateOption(_ option: TMToastView.Option) {
        self.option = option
        _setupSubviewsWithOptionChanged()
    }
    
    func setText(_ text: String) {
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = option.textAlignment
        let attr = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : option.textFont,
            NSAttributedString.Key.foregroundColor : option.textColor,
            NSAttributedString.Key.paragraphStyle : paragrahStyle
        ])
        setAttributedText(attr)
    }
    
    func setAttributedText(_ attr: NSAttributedString) {
        textLabel.attributedText = attr
        layoutIfNeeded()
    }
}

class TMToastViewManager {
    static let shared = TMToastViewManager()
    private let toastView = TMToastView()
    // 待执行的Toast Block 列表：设置文本内容的Block
    private var toastBlockList: [() -> Void] = []
    private var _isToastShowing = false
    private var _toastViewTopConstraint: Constraint? = nil
    
    private init() {  }
    
    func updateOption(_ option: TMToastView.Option) {
        toastView.updateOption(option)
    }
    
    // 添加要执行的Toast Block
    private func addToastBlock(_ toastBlock: @escaping () -> Void) {
        toastBlockList.append(toastBlock)
        scheduleToastBlockIfNeeded()
    }
    
    // 消失的时候，遍历去执行正在等待中的任务
    private func scheduleToastBlockIfNeeded() {
        DispatchQueue.main.safeAsync { [weak self] in
            self?._scheduleToastBlockIfNeeded()
        }
    }
    
    // 内部私有方法，执行任务
    private func _scheduleToastBlockIfNeeded() {
        guard let window = _keyWindow(), !_isToastShowing else {
            return
        }
        if let toastBlock = toastBlockList.first {
            _isToastShowing = true
            window.addSubview(toastView)
            toastView.snp.remakeConstraints { (make) in
                make.top.left.right.equalToSuperview()
            }
            // 设置内容
            toastBlock()
            // 获取大小
            let size = toastView.size
            // 隐藏在statusBar之上
            toastView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                self._toastViewTopConstraint = make.top.equalToSuperview().offset(-size.height).constraint
            }
            window.layoutIfNeeded()
            // 以动画的形式下来
            let option = toastView.option
            UIView.animate(withDuration: option.showDuration, animations: {
                self._toastViewTopConstraint?.update(offset: 0)
                window.layoutIfNeeded()
            }, completion: nil)
            // 以动画的形式上去
            let dalay = option.showDuration + option.stayDuration
            UIView.animate(withDuration: option.dismissDuration, delay: dalay, options: [], animations: {
                self._toastViewTopConstraint?.update(offset: -size.height)
                window.layoutIfNeeded()
            }) { [weak self] (_) in
                self?._toastFinished()
            }
        }
    }
    
    private func _toastFinished() {
        _isToastShowing = false
        if toastBlockList.first != nil {
            _ = toastBlockList.removeFirst()
            toastView.removeFromSuperview()
        }
        delay(0.25) { [weak self] in
            self?._scheduleToastBlockIfNeeded()
        }
    }
    
    private func _keyWindow() -> UIView? {
        return UIApplication.shared.keyWindow
    }
    
    func showToast(_ text: String) {
        addToastBlock { [unowned self] in
            self.toastView.setText(text)
        }
    }
    
    func showToast(_ attr: NSAttributedString) {
        addToastBlock { [unowned self] in
            self.toastView.setAttributedText(attr)
        }
    }
}
