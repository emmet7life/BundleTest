//
//  VCSimpleAnimateLabel.swift
//  SimpleAnimLabel
//
//  Created by jianli chen on 2019/2/25.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import YYText
import YYCategories

// 支持上下翻滚的文本组件
class VCSimpleAnimateLabel: VCLoadFromNibBaseView {
    
    struct Options {
        var upLabelColor: UIColor = UIColor.colorF86A83
        var downLabelColor: UIColor = UIColor.colorWithHexRGBA(0x666666)
        var labelFont: UIFont? = nil
        var labelFontSize: CGFloat = 12.0
    }
    
    @IBOutlet var contentView: UIView!
    
    var upLabel: YYLabel = YYLabel()
    var downLabel: YYLabel = YYLabel()
    var option: Options = Options() {
        didSet {
            setText(with: _text, isUp: _isUp, animated: false)
        }
    }
    var userTappedActionBlock: (() -> Void)? = nil
    
    private var _text = ""
    private var _isUp = false
    
    private(set) var textLayout: YYTextLayout?
    private(set) var textWidth: CGFloat = 0.0
    
    override func initialize() {
        contentView.backgroundColor = .clear
        
        upLabel.isUserInteractionEnabled = false
        upLabel.height = frame.height
        upLabel.textVerticalAlignment = .center
        upLabel.displaysAsynchronously = false
        upLabel.ignoreCommonProperties = true
        upLabel.fadeOnHighlight = false
        upLabel.fadeOnAsynchronouslyDisplay = false
        
        downLabel.isUserInteractionEnabled = false
        downLabel.height = frame.height
        downLabel.textVerticalAlignment = .center
        downLabel.displaysAsynchronously = false
        downLabel.ignoreCommonProperties = true
        downLabel.fadeOnHighlight = false
        downLabel.fadeOnAsynchronouslyDisplay = false
        
        contentView.addSubview(upLabel)
        contentView.addSubview(downLabel)
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func tapGestureAction(_ gesture: UITapGestureRecognizer) {
        userTappedActionBlock?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if upLabel.height != frame.height || downLabel.height != frame.height {
            upLabel.height = frame.height
            downLabel.height = frame.height
        }
    }
    
    @discardableResult
    func setText(with text: String, isUp: Bool, animated: Bool) -> CGFloat {
        return updateLabel(with: text, isUp: isUp, animated: animated)
    }
    
    private func updateLabel(with text: String, isUp: Bool = false, animated: Bool = false) -> CGFloat {
        
        upLabel.height = frame.height
        downLabel.height = frame.height
        
        let oldTextWidth = textWidth
        let oldTextLayout = textLayout
        
        layoutTextSpec(with: text, isUp: isUp)
        
        let newTextWidth = textWidth
        let newTextLayout = textLayout
        
        _text = text
        _isUp = isUp
        
        if animated {
            upLabel.width = oldTextWidth
            upLabel.textLayout = oldTextLayout
            downLabel.width = newTextWidth
            downLabel.textLayout = newTextLayout
        } else {
            upLabel.width = newTextWidth
            upLabel.textLayout = newTextLayout
        }
        
        let finalFrameBlock = { [weak self] in
            guard let SELF = self else { return }
            SELF.upLabel.top = 0.0
            SELF.downLabel.size = SELF.upLabel.size
            if isUp {
                SELF.downLabel.top = -SELF.upLabel.height
            } else {
                SELF.downLabel.top = SELF.upLabel.height
            }
        }
        
        if animated {
            let animateDuration: TimeInterval = 0.26
            if isUp {
                // 非赞 -> 赞，动画从当前位置往上滚动
                upLabel.top = 0.0
                downLabel.top = upLabel.height
                UIView.animate(withDuration: animateDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.upLabel.top = -self.upLabel.height
                    self.downLabel.top = 0.0
                }) { [weak self] (_) in
                    self?.upLabel.width = newTextWidth
                    self?.upLabel.textLayout = newTextLayout
                    finalFrameBlock()
                }
            } else {
                // 赞 -> 非赞，动画从当前位置往下滚动
                upLabel.top = 0.0
                downLabel.top = -upLabel.height
                UIView.animate(withDuration: animateDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.upLabel.top = self.upLabel.height
                    self.downLabel.top = 0.0
                }) { [weak self] (_) in
                    self?.upLabel.width = newTextWidth
                    self?.upLabel.textLayout = newTextLayout
                    finalFrameBlock()
                }
            }
        } else {
            // 直接布局likeUpLabel显示即可
            finalFrameBlock()
        }
        
        return newTextWidth
    }
    
    func meatureTextWidth(with text: String) -> CGFloat {
        return createLayout(with: text, textColor: option.upLabelColor).width
    }
    
    private func layoutTextSpec(with text: String, isUp: Bool) {
        let layoutResult = createLayout(with: text, textColor: isUp ? option.upLabelColor : option.downLabelColor)
        if let layout = layoutResult.layout {
            textLayout = layout
            textWidth = layoutResult.width
        }
    }
    
    private func createLayout(with text: String, textColor: UIColor) -> (layout: YYTextLayout?, width: CGFloat) {
        let font = option.labelFont ?? UIFont.systemFont(ofSize: option.labelFontSize)
        let container = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        container.maximumNumberOfRows = 1
        container.truncationType = .end
        
        let mutableText: NSMutableAttributedString = NSMutableAttributedString(string: text)
        mutableText.yy_color = textColor
        mutableText.yy_font = font
        
        if let layout = YYTextLayout(container: container, text: mutableText) {
            return (layout, YYTextCGFloatPixelRound(layout.textBoundingSize.width))
        }
        
        return (nil, 0)
    }
}
