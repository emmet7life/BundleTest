//
//  ELTabMenu.swift
//  SwiftKit
//
//  Created by 陈建立 on 4/20/17.
//  Copyright © 2017 陈建立. All rights reserved.
//

import Foundation
import UIKit

// MARK: 辅助工具类
public class ELTabMenuUtils {
    
    static let share = ELTabMenuUtils()
    
    fileprivate var displayLinkForTransition: CADisplayLink?
    fileprivate var _fromFloat: CGFloat = 0.0
    fileprivate var _toFloat: CGFloat = 0.0
    fileprivate var _markTransitionTimeStamp: CFTimeInterval = 0.0
    fileprivate var _transitionDuration: CFTimeInterval = 0.25
    
    typealias ELTabMenuTransitionCallback = (Bool, CGFloat) -> Void
    fileprivate var _callback: ELTabMenuTransitionCallback?
    
    fileprivate func transitionFloat(_ fromFloat: CGFloat, toFloat: CGFloat, progress: CGFloat) -> CGFloat {
        let t = progress
        let f = 1 - t
        return t * toFloat + f * fromFloat
    }
    
    func transition(_ fromFloat: CGFloat, toFloat: CGFloat, duration: CFTimeInterval = 0.1, callback: @escaping ELTabMenuTransitionCallback) {
        _fromFloat = fromFloat
        _toFloat = toFloat
        _transitionDuration = duration
        _callback = callback
        
        _markTransitionTimeStamp = CACurrentMediaTime()
        
        if displayLinkForTransition == nil {
            displayLinkForTransition = CADisplayLink.init(target: self, selector: #selector(updateTransition(_:)))
            displayLinkForTransition?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc fileprivate func updateTransition(_ link: CADisplayLink) {
        var progress = _transitionDuration > 0 ? (link.timestamp - _markTransitionTimeStamp) / _transitionDuration : 1
        progress = max(0, min(1, progress))
        let transitioningFloat = transitionFloat(_fromFloat, toFloat: _toFloat, progress: CGFloat(progress))
        _callback?(progress >= 1, transitioningFloat)
        
        if (progress >= 1) {
            if displayLinkForTransition != nil {
                displayLinkForTransition?.invalidate()
                displayLinkForTransition = nil
            }
        }
    }
    
}

// Tab Item的宽度模式
public enum ELTabMenuItemWidthMode {
    case equal         // 等宽
    case dynamic    // 动态计算自身宽度
}

// 整体Tab Item的布局模式
public enum ELTabMenuItemLayoutMode {
    case free       // 从左到右自由布局
    case full       // 当所有Item的总宽度小于父视图宽度时也让其平铺在父视图中
}

// scrollBar滚动条对齐的对象是其父视图还是UIButton中的UILabel文本组件
public enum ELTabMenuScrollBarAlignPosition {
    case alignView // it`s superwiew
    case alignText // the UIButton`s UILabel`s Edge
}

// scrollBar滚动条的垂直向布局位置
// top:     顶部
// center: 中间
// bottom: 底部
public enum ELTabMenuVerticalPosition {
    case top
    case center
    case bottom
}

// scrollBar滚动条的水平向布局位置
public enum ELTabMenuScrollBarLeadingPosition {
    case center
    case left
}

// scrollBar滚动条的z轴布局位置，是在所有Item前还是在所有Item后放置
public enum ELTabMenuScrollBarZAnchorPosition {
    case front
    case behind
}

public func == (lhs: ELTabMenuVerticalPosition, rhs: ELTabMenuVerticalPosition) -> Bool {
    switch (lhs, rhs) {
    case (.top, .top): return true
    case (.center, .center): return true
    case (.bottom, .bottom): return true
    default:  return false
    }
}

fileprivate class ELTabMenuPointShapeLayer: CAShapeLayer {
    
}

public struct ELTabMenuOptions {
    // common style
    var padding: CGFloat = 8.0
    var margin: CGFloat = 20.0
    var textFontSize: CGFloat = 16.0
    var textFont: UIFont?
    var bold = false
    
    // 布局时头尾Item是否也加上margin
    var edgeNeedMargin: Bool = true
    
    var normalColor: UIColor? = ELTabMenu.ELTabMenuConstant.kDefaultNormalColor
    var selectedColor: UIColor? = ELTabMenu.ELTabMenuConstant.kDefaultFocusColor
    
    var maxItemWidth: CGFloat = 0.0// 最大宽度限制
    var defaultItemIndex: Int = 0// 默认选中项索引
    
    var itemWidthMode: ELTabMenuItemWidthMode = .dynamic
    var itemLayoutMode: ELTabMenuItemLayoutMode = .full
    
    // scroll bar style
    var scrollBarAlpha: CGFloat = 1.0
    var scrollBarColor: UIColor? = ELTabMenu.ELTabMenuConstant.kDefaultFocusColor
    var scrollBarHeight = ELTabMenu.ELTabMenuConstant.kDefaultScrollBarHeight {
        didSet {
            scrollBarLayerCornerRadius = scrollBarHeight * 0.5
        }
    }
    var scrollBarPosition: ELTabMenuVerticalPosition = .bottom
    var scrollBarAlignPosition: ELTabMenuScrollBarAlignPosition = .alignView
    var scrollBarPositionOffset: CGFloat = 0.0// 偏移量
    var scrollBarLeadingPosition: ELTabMenuScrollBarLeadingPosition = .center
    var scrollBarZPosition: ELTabMenuScrollBarZAnchorPosition = .behind
    var isUseScrollBarCornerRadiusStyle = false
    var scrollBarLayerCornerRadius: CGFloat = ELTabMenu.ELTabMenuConstant.kDefaultScrollBarHeight * 0.5
    var scrollBarWidthPercent: CGFloat = 1.0 { // 滚动条占据整个Item宽度的百分比，默认与Item等宽
        didSet {
            autoAdjustScrollBarWidthPercent = false
        }
    }
    var scrollBarWidth: CGFloat = -1.0 {
        didSet {
            if scrollBarWidth > 0 {
                scrollBarWidthPercent = 0.0
            }
        }
    }
    var autoAdjustScrollBarWidthPercent = true// 是否自动调整scrollBarWidthPercent，默认true
    
    // 2017/08/01
    // 可配置Tab之间的分隔视图
    var isShowSeperatorView = false
    var seperatorViewSize = CGSize(width: 1, height: 10) {
        didSet {
            isShowSeperatorView = true
        }
    }
    
    var seperatorViewImage: UIImage? {
        didSet {
            isShowSeperatorView = true
        }
    }
    
    var seperatorViewBackgroundImage: UIImage? {
        didSet {
            isShowSeperatorView = true
        }
    }
    
    var seperatorViewBackgroundColor = UIColor.colorWithHexRGBA(0xD8D8D8) {
        didSet {
            isShowSeperatorView = true
        }
    }
    
    var sepetatorViewPosition: ELTabMenuVerticalPosition = .center {
        didSet {
            isShowSeperatorView = true
        }
    }
    
    // debug mode
    var debug = false
    
    // 2018.04.14
    var normalTextFont: UIFont?
    var selectedTextFont: UIFont?
    
    var normalTextFontSize: CGFloat?
    var selectedTextFontSize: CGFloat?
    
    // 支持背景和自定义Scroll视图组件
    var backgroundView: UIView?
    var scrollIndicatorView: UIView?
    
    // 2018.04.18 支持打点
    var pointOffset: CGPoint = .zero          // 默认在文本组件的右上方，可设置该偏移量做调整
    var pointRadius: CGFloat = 4.0            // 小圆点半径
    var pointColor: UIColor = UIColor.colorWithHexRGBA(0xFF4C6A)   // 打点的颜色
    
    // 2018.04.23
    var isScrollBarAutoScrollWithOffsetChanged = true  // 外部offset变化时，scrollBar要不要实时跟着变化(如果不实时跟着变化，那么外部变化结束时要手动调用scrollTo)
    
    // 2018.10.12 支持气泡
    var bubbleOffset: CGPoint = .zero
    var bubbleSize: CGSize = CGSize(width: 30.0, height: 18.0)
    
    // 2019.08.14 支持文本右侧有一个小角标，点击旋转
    var textTailIconNameNormal: String? = nil
    var textTailIconNameSelected: String? = nil
    var textTailIconOffset: CGPoint = .zero
    var textTailIconSize: CGSize = .zero
    var textTailIconRotationAngle: CGFloat = CGFloat.pi
    var textTailIconContentMode: UIView.ContentMode = .scaleAspectFill
    var textTailIconClipsToBounds: Bool = false
    var isTextTailIconAutoPerformTransfrom: Bool = true
    var isTextTailIconEnabled: Bool = false
    
    // 2019.08.13 支持自定义宽度属性，用于保证测量时的准确性
    var measureWidth: CGFloat? = nil// screenWidth
    
    // 2019.09.20 支持固定宽度
    var fixedItemSize: CGSize? = nil
    // 2019.09.24 支持由外部动态创建富文本(ELTabMenuItemTextProtocol: 菜单项，Int: 菜单项索引，Int: 当前菜单项索引，Bool: 当前菜单项是否选中)
    var dynamicCreateAttributedStringBlock: ((ELTabMenuItemTextProtocol, Int, Int, Bool) -> NSAttributedString?)? = nil
    // 菜单项行数
    var numberOfLines: Int = 1
}

@objc public protocol ELTabMenuDelegate: class, NSObjectProtocol {
    // 跨越多个Tab时，需要将disable参数设置为true
    @objc optional func switchToTab(_ index: Int, disable: Bool)
    // 点击当前高亮了的Tab
    @objc optional func tappedCurrentFocusedTab(_ index: Int)
    @objc optional func tabMenuScrollViewDelegate(_ tabMenu: ELTabMenu) -> UIScrollViewDelegate?
    
    // 以下协议的方法为上面方法的加强版本！！
    // 1. 只是增强版本而已，多传了ELTabMenu等额外的数据，部分界面不持有ELTabMenu，所以在方法中传入，方便使用
    // 2. 各自的版本选择实现其中一个即可，否则会调用两次
    
    @objc optional func switchToTab(_ tabMenu: ELTabMenu, preIndex: Int, newIndex: Int, disable: Bool)
    @objc optional func tappedCurrentFocusedTab(_ tabMenu: ELTabMenu, index: Int)
}

public protocol ELTabMenuItemTextProtocol {
    var tabMenuItemAttributedString: NSAttributedString { get }
    var tabMenuItemString: String { get }
}

extension String: ELTabMenuItemTextProtocol {
    public var tabMenuItemAttributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    public var tabMenuItemString: String {
        return self
    }
}

extension NSAttributedString: ELTabMenuItemTextProtocol {
    public var tabMenuItemAttributedString: NSAttributedString {
        return self
    }
    
    public var tabMenuItemString: String {
        return self.string
    }
}

// @IBDesignable
open class ELTabMenu: UIView {
    
    struct ELTabMenuConstant {
        static let kDefaultNormalColor = UIColor.mainColor
        static let kDefaultFocusColor = UIColor.colorWithHexRGBA(0xFF4C6A)
        static let kDefaultScrollBarHeight: CGFloat = 2.0
        static let kDefaultItemWidth: CGFloat = 100.0
        
        static var kScreenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
        static var kScreenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
    }
    
    // 各个Item的容器父视图
    fileprivate lazy var _contentView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        return scrollView
    }()
    
    // 滚动条指示器视图
    fileprivate lazy var _scrollBar: UIView = { [unowned self] in
        let scrollBar = UIView()
        if let scrollBarColor = self.options.scrollBarColor {
            scrollBar.backgroundColor = scrollBarColor
        } else {
            scrollBar.backgroundColor = UIColor.mainColor
        }
        if self.options.isUseScrollBarCornerRadiusStyle {
            scrollBar.layer.cornerRadius = self.options.scrollBarLayerCornerRadius
        }
        return scrollBar
        }()
    
    // TODO 开放视图属性给外部?
    public var contentView: UIScrollView {
        return _contentView
    }
    
    public var scrollBar: UIView {
        return options.scrollIndicatorView ?? _scrollBar
    }
    
    public var backgroundView: UIView? {
        return options.backgroundView
    }
    
    // 控制是否可以切换
    fileprivate var _switchControl: Bool = true
    
    fileprivate var _tabItemViewArr = [UIView]()
    
    // Data
    fileprivate var _cacheItemWidths = [CGFloat]()
    fileprivate var _currentTabIndex: Int = 0
    fileprivate var _currentOffset = CGPoint.zero
    
    var currentIndex: Int {
        return _currentTabIndex
    }
    
    weak var delegate: ELTabMenuDelegate?
    
    var options: ELTabMenuOptions = ELTabMenuOptions()
    
    // 2018.04.18 - 支持打点
    fileprivate var _pointMarkTabIndexes: Set = Set<Int>()
    
    // 2018.10.12 - 支持气泡
    fileprivate var _bubbleMarkTabIndexes: Set = Set<Int>()
    fileprivate var _bubbleTabIndexBubbleCountMap: [Int: Int] = [:]
    
    // 2019.08.14 - 支持文本右侧显示小角标，可旋转
    fileprivate var _textTailIconMarkTabIndexes: Set = Set<Int>()
    /* tabIndex 映射 视图的transform状态
     false -> CGAffineTransform.identity
     true  ->CGAffineTransform(rotationAngle: _textTailIconTransformDuration)
     */
    fileprivate var _textTailIconTabIndexMapToTransformState: [Int: Bool] = [:]
    fileprivate var _isTextTailIconTransformFinished = true
    fileprivate var _textTailIconTransformDuration: TimeInterval = 0.30
    fileprivate var _titles = [ELTabMenuItemTextProtocol]()
    
    var tabTitles: [ELTabMenuItemTextProtocol] {
        get {
            return _titles
        }
        
        set {
            layoutIfNeeded()
            
            _titles = newValue
            
            var contentSize = CGSize.zero
            contentSize.height = _height
            
            // 缓存文本所占宽度
            var cacheTabTextWidths = [CGFloat]()
            
            // 1.先将所有Item所需的宽度计算一遍，并将结果缓存起来备用
            _cacheItemWidths.removeAll()
            for title in _titles {
                if let fixedSize = options.fixedItemSize {
                    _cacheItemWidths.append(fixedSize.width)
                } else {
                    // TODO 这里需要算上padding吗 ??
                    let mutableAttrString = NSMutableAttributedString(attributedString: title.tabMenuItemAttributedString)
                    mutableAttrString.addAttributes([NSAttributedString.Key.font : selectedTextFont], range: mutableAttrString.yy_rangeOfAll())
                    let textSize = mutableAttrString.bound(for: CGFloat.greatestFiniteMagnitude)
                    let width = textSize.width + options.padding * 2.0
                    _cacheItemWidths.append(width)
                }
            }
            cacheTabTextWidths.append(contentsOf: _cacheItemWidths)
            
            if options.fixedItemSize == nil {
                // 2.判断是否配置了最大宽度
                let _max = _cacheItemWidths.max() ?? ELTabMenuConstant.kDefaultItemWidth
                let maxMeasureItemWidth: CGFloat = options.maxItemWidth > 0 ? min(options.maxItemWidth, _max) : _max
                
                // 3.处理之前缓存的Item宽度
                // 3.1 等宽模式时，所有Item的宽度都将是一致的，等于maxMeasureItemWidth
                // 3.2 动态模式时，item的宽度使用Item自身测量出的宽度值但不大于maxMeasureItemWidth
                _cacheItemWidths = _cacheItemWidths.map {
                    switch options.itemWidthMode {
                    case .equal:
                        return maxMeasureItemWidth
                    case .dynamic:
                        return min(maxMeasureItemWidth, $0)
                    }
                }
                
                // 4.当布局模式为平铺时，需要进一步判断总宽度是否仍然小于屏幕宽度，如果小，则需要将差值部分平分给各个Item
                
                // 4.1 计算时，需要把margin算上
                var marginNeedNum = _titles.count - 1
                marginNeedNum += (options.edgeNeedMargin ? 2 : 0)
                let sum = _cacheItemWidths.reduce(0, +) + CGFloat(marginNeedNum) * options.margin
                
                if sum < _width && options.itemLayoutMode == .full {
                    let dis = (_width - sum) / CGFloat(_titles.count) // 剩余多少宽度值平分给每个Item
                    _cacheItemWidths = _cacheItemWidths.map {
                        return $0 + dis
                    }
                }
                
                // 5. 当Item数目小于等于3个时，并且布局模式是平铺时，如果某Item的文字数目很少，
                // 可能会造成scrollBar进度条的宽度(默认与Item宽度一致)远比文字宽度大的情况，造成界面不美观，因此这里需要额外处理
                if options.autoAdjustScrollBarWidthPercent && _titles.count <= 3 {
                    // 纯文本在各个Tab所在Button中的占比
                    var tempIndex: Int = 0
                    let percents = cacheTabTextWidths.map { (element) -> CGFloat in
                        let percent = element / _cacheItemWidths[tempIndex]
                        tempIndex += 1
                        return percent
                    }
                    // 当最大占比小于等于0.8时，使用max
                    if let max = percents.max(), max <= 0.8 {
                        // TODO 目前是每个Item的宽度都将统一乘以scrollBarWidthPercent得到最终的宽度
                        // 是否需要为每个Item单独计算一个scrollBarWidthPercent?，因为每个Item的占比可能是不一样的!
                        options.scrollBarWidthPercent = max
                    }
                }
            }
            
            // 横竖屏切换时，不提取数据，直接使用_currentTabIndex
            if _currentTabIndex == 0 {
                let initIndex = min(max(0, options.defaultItemIndex), _titles.count - 1)
                _currentTabIndex = initIndex
            }
            
            // 6. 重新设置内容时重置视图
            _contentView.subviews.forEach { $0.removeFromSuperview() }
            _tabItemViewArr.forEach { $0.removeFromSuperview() }
            _tabItemViewArr.removeAll()
            
            // 7. 开始布局
            
            // add scroll bar
            if let scrollIndicatorView = options.scrollIndicatorView {
                // custom scrollbar view
                _contentView.addSubview(scrollIndicatorView)
            } else {
                // default scrollbar view
                _scrollBar.alpha = options.scrollBarAlpha
                _scrollBar.layer.masksToBounds = true
                //                _scrollBar.layer.cornerRadius = self.options.scrollBarHeight * 0.5
                _contentView.addSubview(_scrollBar)
            }
            
            var scrollBarY: CGFloat = 0
            switch options.scrollBarPosition {
            case .top:
                if options.scrollBarAlignPosition == .alignView {
                    scrollBarY = 0
                } else if options.scrollBarAlignPosition == .alignText {
                    let textHeight = tabItemMaxBoundTextHeight()
                    scrollBarY = (_height - textHeight) * 0.5
                }
            case .center:
                scrollBarY = (_height - options.scrollBarHeight) * 0.5
            case .bottom:
                if options.scrollBarAlignPosition == .alignView {
                    scrollBarY = _height - options.scrollBarHeight
                } else if options.scrollBarAlignPosition == .alignText {
                    let textHeight = tabItemMaxBoundTextHeight()
                    scrollBarY = (_height + textHeight) * 0.5 - options.scrollBarHeight
                }
            }
            scrollBarY += options.scrollBarPositionOffset// * UIScreen.main.scale
            scrollBar.frame = CGRect(x: scrollBar_x(_currentTabIndex), y: scrollBarY, width: scrollBar_width(_currentTabIndex), height: options.scrollBarHeight)
            
            // line view
            let createSeperatorView = { () -> UIButton in
                let view = UIButton(type: .custom)
                view.frame.size = self.options.seperatorViewSize
                view.setImage(self.options.seperatorViewImage, for: UIControl.State())
                view.setBackgroundImage(self.options.seperatorViewBackgroundImage, for: UIControl.State())
                view.backgroundColor = self.options.seperatorViewBackgroundColor
                return view
            }
            
            // add tab item
            let lastIndex = _titles.count - 1
            var x: CGFloat = 0.0
            if options.edgeNeedMargin {
                x += options.margin
            }
            for text in _titles.enumerated() {
                let title = text.element
                let index = text.offset
                let width = _cacheItemWidths[index]
                
                let button = UIButton(type: .custom)
                button.tag = index + 999
                button.backgroundColor = .clear
                button.addTarget(self, action: #selector(onItemTapped(_:)), for: .touchUpInside)
                let isCurrentTabIndex = index == _currentTabIndex
                let attr = createMutableAttributedString(title: title, tabIndex: index, currentTabIndex: _currentTabIndex, isCurrentTabIndex: isCurrentTabIndex)
                button.setAttributedTitle(attr, for: .normal)
                button.frame = CGRect(x: x, y: 0, width: width, height: _height)
                _contentView.addSubview(button)
                _tabItemViewArr.append(button)
                button.titleLabel?.numberOfLines = options.numberOfLines
                
                x += width
                contentSize.width = x
                if options.edgeNeedMargin && index == lastIndex {
                    contentSize.width += options.margin
                }
                
                if options.isShowSeperatorView && index != lastIndex{
                    let seperatorView = createSeperatorView()
                    let seperatorCenterX = x + options.margin * 0.5
                    seperatorView.centerX = seperatorCenterX
                    switch options.sepetatorViewPosition {
                    case .top:
                        seperatorView.top = 0.0
                    case .center:
                        seperatorView.centerY = _contentView.centerY
                    case .bottom:
                        seperatorView.bottom = _contentView.bottom
                    }
                    _contentView.addSubview(seperatorView)
                }
                x += options.margin
                
                if options.debug {
                    button.layer.borderColor = UIColor.red.cgColor
                    button.layer.borderWidth = 0.5
                    
                    button.titleLabel?.layer.borderColor = UIColor.black.cgColor
                    button.titleLabel?.layer.borderWidth = 0.5
                }
            }
            
            //            if options.debug {
            //                scrollBar.layer.borderColor = UIColor.yellow.cgColor
            //                scrollBar.layer.borderWidth = 0.25
            //            }
            
            _contentView.contentSize = contentSize
            
            // add background view
            if let _backgroundView = backgroundView {
                _backgroundView.origin = .zero
                _backgroundView.size = intrinsicContentSize
                addSubview(_backgroundView)
                sendSubviewToBack(_backgroundView)
            }
            
            if options.scrollBarZPosition == .front {
                _contentView.bringSubviewToFront(scrollBar)
            }
            
            addTextTailIconIfNeeded()
        }
    }
    
    
    private func createMutableAttributedString(title: ELTabMenuItemTextProtocol, tabIndex: Int, currentTabIndex: Int, isCurrentTabIndex: Bool) -> NSAttributedString {
        if let dynamicAttr = options.dynamicCreateAttributedStringBlock?(title, tabIndex, currentTabIndex, isCurrentTabIndex) {
            return dynamicAttr
        }
        let isCurrentTabSelected = tabIndex == currentTabIndex || isCurrentTabIndex
        let attr = title.tabMenuItemAttributedString
        let mutableAttr = NSMutableAttributedString(attributedString: attr)
        mutableAttr.addAttributes([
            NSAttributedString.Key.font : isCurrentTabSelected ? selectedTextFont : normalTextFont,
            NSAttributedString.Key.foregroundColor : (isCurrentTabSelected ? options.selectedColor : options.normalColor) ?? .black
            ], range: attr.yy_rangeOfAll())
        return mutableAttr
    }
    
    open override var intrinsicContentSize: CGSize {
        return bounds.size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitialize()
    }
    
    fileprivate func didInitialize() {
        clipsToBounds = false
        _contentView.clipsToBounds = false
        _contentView.frame = bounds
        addSubview(_contentView)
    }
    
    //    override open func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //    }
    //
    //    override open func layoutSubviews() {
    //        super.layoutSubviews()
    //    }
    
    // MARK: - 支持打点
    
    /// 添加打点
    ///
    /// - Parameter tabIndex: Tab索引
    func addPoint(to tabIndex: Int) {
        _pointMarkTabIndexes.insert(tabIndex)
        updatePointIfNeeded()
    }
    
    /// 移除打点
    ///
    /// - Parameter tabIndex: Tab索引
    func removePoint(with tabIndex: Int) {
        _pointMarkTabIndexes.remove(tabIndex)
        updatePointIfNeeded()
    }
    
    /// 移除所有打点
    func removeAllPoint() {
        _pointMarkTabIndexes.removeAll()
        updatePointIfNeeded()
    }
    
    /// 内部方法，用来打点和移除打点
    fileprivate func updatePointIfNeeded() {
        for tabIndex in 0 ..< _tabItemViewArr.count {
            if let tabItemButton = validTabItemButton(tabIndex),
                let sublayers = tabItemButton.layer.sublayers,
                let titleLabel = tabItemButton.titleLabel {
                
                let pointShaperLayers = sublayers.filter { $0.classForCoder == ELTabMenuPointShapeLayer.self }
                
                if _pointMarkTabIndexes.contains(tabIndex) {
                    if pointShaperLayers.isEmpty {
                        // add layer
                        let layer = createPointShapeLayer(with: tabIndex, titleLabel)
                        tabItemButton.layer.addSublayer(layer)
                    }
                } else {
                    // remove layer
                    pointShaperLayers.forEach { $0.removeFromSuperlayer() }
                }
                
            }
        }
    }
    
    fileprivate func createPointShapeLayer(with tabIndex: Int, _ titleLabel: UILabel) -> CALayer {
        let center = titleLabel.center
        let arcCenter = CGPoint(x: options.pointRadius, y: options.pointRadius)
        let bezier = UIBezierPath(arcCenter: arcCenter, radius: options.pointRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let shapeLayer = ELTabMenuPointShapeLayer()
        shapeLayer.fillColor = options.pointColor.cgColor
        shapeLayer.path = bezier.cgPath
        
        let x = center.x + titleLabel.width * 0.5 + options.pointOffset.x
        let y = center.y - titleLabel.height * 0.5 + options.pointOffset.y
        let width = options.pointRadius * 2
        let height = width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        shapeLayer.frame = frame
        return shapeLayer
    }
    
    // MARK: - 2018.10.12 支持气泡 角标
    func addBubble(with tabIndex: Int, count: Int? = nil) {
        layoutIfNeeded()
        _bubbleMarkTabIndexes.insert(tabIndex)
        _bubbleTabIndexBubbleCountMap[tabIndex] = count
        updateBubbleIfNeeded()
    }
    
    func removeBubble(with tabIndex: Int) {
        layoutIfNeeded()
        _bubbleMarkTabIndexes.remove(tabIndex)
        _bubbleTabIndexBubbleCountMap[tabIndex] = nil
        updateBubbleIfNeeded()
    }
    
    func removeAllBubble() {
        layoutIfNeeded()
        _bubbleMarkTabIndexes.removeAll()
        _bubbleTabIndexBubbleCountMap.removeAll()
        updateBubbleIfNeeded()
    }
    
    /// 内部方法，用来打点和移除打点
    fileprivate func updateBubbleIfNeeded() {
        for tabIndex in 0 ..< _tabItemViewArr.count {
            if let tabItemButton = validTabItemButton(tabIndex), let titleLabel = tabItemButton.titleLabel {
                
                let bubbleViews = tabItemButton.subviews.compactMap { $0 as? VCBubbleView }
                
                if _bubbleMarkTabIndexes.contains(tabIndex) {
                    if let bubbleView = bubbleViews.first {
                        // update bubble count
                        bubbleView.changeDotCount(_formatBubbleCount(with: tabIndex))
                    } else {
                        // add bubble view
                        let bubbleView = createBubbleView(with: tabIndex, titleLabel)
                        tabItemButton.addSubview(bubbleView)
                    }
                } else {
                    // remove bubble view
                    bubbleViews.forEach { $0.removeFromSuperview() }
                }
            }
        }
    }
    
    fileprivate func createBubbleView(with tabIndex: Int, _ titleLabel: UILabel) -> UIView {
        let center = titleLabel.center
        let x = center.x + titleLabel.width * 0.5 + options.bubbleOffset.x
        let y = center.y - titleLabel.height * 0.5 + options.bubbleOffset.y
        let frame = CGRect(x: x, y: y, width: options.bubbleSize.width, height: options.bubbleSize.height)
        let bubbleView = VCBubbleView(frame: frame)
        bubbleView.changeDotCount(_formatBubbleCount(with: tabIndex))
        if options.debug {
            bubbleView.layer.borderWidth = 0.5
            bubbleView.layer.borderColor = UIColor.blue.cgColor
        }
        return bubbleView
    }
    
    fileprivate func _formatBubbleCount(with tabIndex: Int) -> String {
        if let bubbleCount = _bubbleTabIndexBubbleCountMap[tabIndex] {
            return bubbleCount > 99 ? "99+" : "\(bubbleCount)"
        }
        return "0"
    }
    
    // MARK: - 2019.08.14 支持文本右侧显示小角标，点击旋转
    fileprivate func addTextTailIconIfNeeded() {
        guard options.isTextTailIconEnabled else { return }
        layoutIfNeeded()
        for tabIndex in 0 ..< _tabItemViewArr.count {
            _textTailIconMarkTabIndexes.insert(tabIndex)
        }
        updateTextTailIconIfNeeded()
    }
    
    func addTextTailIcon(with tabIndex: Int) {
        layoutIfNeeded()
        _textTailIconMarkTabIndexes.insert(tabIndex)
        updateTextTailIconIfNeeded()
    }
    
    func removeTextTailIcon(with tabIndex: Int) {
        layoutIfNeeded()
        _textTailIconMarkTabIndexes.remove(tabIndex)
        updateTextTailIconIfNeeded()
    }
    
    func removeAllTextTailIcon() {
        layoutIfNeeded()
        _textTailIconMarkTabIndexes.removeAll()
        _textTailIconTabIndexMapToTransformState.removeAll()
        updateTextTailIconIfNeeded()
    }
    
    fileprivate func updateTextTailIconStateIfNeeded(with tabIndex: Int, isForceLayout: Bool = false, duration: TimeInterval? = nil, isReverse: Bool = true) {
        guard options.isTextTailIconAutoPerformTransfrom else { return }
        if let isSelected = _textTailIconTabIndexMapToTransformState[tabIndex] {
            if isSelected {
                if isReverse {
                    updateTextTailIconToNormal(with: tabIndex, isForceLayout: isForceLayout, duration: duration)
                } else {
                    updateTextTailIconToSelected(with: tabIndex, isForceLayout: isForceLayout, duration: duration)
                }
            } else {
                if isReverse {
                    updateTextTailIconToSelected(with: tabIndex, isForceLayout: isForceLayout, duration: duration)
                } else {
                    updateTextTailIconToNormal(with: tabIndex, isForceLayout: isForceLayout, duration: duration)
                }
            }
        } else {
            updateTextTailIconToNormal(with: tabIndex, isForceLayout: isForceLayout, duration: duration)
        }
    }
    
    func updateTextTailIconToNormal(with tabIndex: Int, isForceLayout: Bool = false, duration: TimeInterval? = nil) {
        guard _isTextTailIconTransformFinished || isForceLayout else { return }
        guard let imageView = updateTextTailIconImage(to: options.textTailIconNameNormal, tabIndex: tabIndex) else {
            _isTextTailIconTransformFinished = true
            return
        }
        _textTailIconTabIndexMapToTransformState[tabIndex] = false
        _isTextTailIconTransformFinished = false
        let transform = CGAffineTransform.identity
        let _duration = duration ?? _textTailIconTransformDuration
        if _duration <= 0 {
            _isTextTailIconTransformFinished = true
            imageView.transform = transform
        } else {
            UIView.animate(withDuration: _duration, animations: {
                imageView.transform = transform
            }) { [weak self] (_) in
                self?._isTextTailIconTransformFinished = true
            }
        }
    }
    
    func updateTextTailIconToSelected(with tabIndex: Int, isForceLayout: Bool = false, duration: TimeInterval? = nil) {
        guard _isTextTailIconTransformFinished || isForceLayout else { return }
        guard let imageView = updateTextTailIconImage(to: options.textTailIconNameSelected, tabIndex: tabIndex) else {
            _isTextTailIconTransformFinished = true
            return
        }
        _textTailIconTabIndexMapToTransformState[tabIndex] = true
        _isTextTailIconTransformFinished = false
        let transform = CGAffineTransform(rotationAngle: self.options.textTailIconRotationAngle)
        let _duration = duration ?? _textTailIconTransformDuration
        if _duration <= 0 {
            _isTextTailIconTransformFinished = true
            imageView.transform = transform
        } else {
            UIView.animate(withDuration: _duration, animations: {
                imageView.transform = transform
            }) { [weak self] (_) in
                self?._isTextTailIconTransformFinished = true
            }
        }
    }
    
    fileprivate func updateTextTailIconImage(to name: String? = nil, tabIndex: Int) -> UIView? {
        if let tabItemButton = validTabItemButton(tabIndex) {
            let textTailIconViews = tabItemButton.subviews.compactMap { $0 as? ELTabMenuTextTailIconImageView }
            if let textTailIconView = textTailIconViews.first {
                if let _name = name, let image = UIImage(named: _name) {
                    textTailIconView.image = image
                } else {
                    textTailIconView.image = nil
                }
                return textTailIconView
            }
        }
        return nil
    }
    
    fileprivate func updateTextTailIconIfNeeded() {
        for tabIndex in 0 ..< _tabItemViewArr.count {
            if let tabItemButton = validTabItemButton(tabIndex), let titleLabel = tabItemButton.titleLabel {
                let textTailIconViews = tabItemButton.subviews.compactMap { $0 as? ELTabMenuTextTailIconImageView }
                if _textTailIconMarkTabIndexes.contains(tabIndex) {
                    if textTailIconViews.isEmpty {
                        let textTailIconView = createTextTailIconView(titleLabel)
                        tabItemButton.addSubview(textTailIconView)
                    }
                    updateTextTailIconStateIfNeeded(with: tabIndex, isForceLayout: true, duration: 0, isReverse: false)
                } else {
                    _textTailIconTabIndexMapToTransformState[tabIndex] = nil
                    textTailIconViews.forEach { $0.removeFromSuperview() }
                }
            }
        }
    }
    
    fileprivate func createTextTailIconView(_ titleLabel: UILabel) -> UIView {
        let center = titleLabel.center
        let frame = titleLabel.frame
        let x = frame.maxX + options.textTailIconOffset.x
        let y = center.y - options.textTailIconSize.height * 0.5 + options.textTailIconOffset.y
        let textTailIconView = ELTabMenuTextTailIconImageView(frame: CGRect(origin: CGPoint(x: x, y: y), size: options.textTailIconSize))
        textTailIconView.contentMode = options.textTailIconContentMode
        textTailIconView.clipsToBounds = options.textTailIconClipsToBounds
        if let name = options.textTailIconNameNormal, let image = UIImage(named: name) {
            textTailIconView.image = image
        } else {
            textTailIconView.image = nil
        }
        return textTailIconView
    }
    
    fileprivate class ELTabMenuTextTailIconImageView: UIImageView { }
    
    // MARK: - 内部私有属性及方法
    fileprivate var _width: CGFloat {
        return options.measureWidth ?? bounds.size.width
    }
    
    fileprivate var _height: CGFloat {
        return bounds.size.height
    }
    
    //    fileprivate lazy var measureLabel: UILabel = { [unowned self] in
    //        let label = UILabel()
    //        label.font = self.normalTextFont
    //        return label
    //        }()
    //
    //    fileprivate func measureSize(_ text: String) -> CGSize {
    //        let label = measureLabel
    //        let size = CGSize(width: CGFloat(MAXFLOAT), height: _height)
    //        label.text = text
    //        return label.sizeThatFits(size)
    //    }
    
    fileprivate var font: UIFont {
        if let textFont = options.textFont {
            return textFont
        }
        return options.bold ? UIFont.boldSystemFont(ofSize: options.textFontSize) : UIFont.systemFont(ofSize: options.textFontSize)
    }
    
    fileprivate lazy var normalTextFont: UIFont = { [unowned self] in
        if let font = self.options.normalTextFont {
            return font
        }
        if let fontSize = self.options.normalTextFontSize {
            return self.options.bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        }
        return self.font
        }()
    
    fileprivate lazy var selectedTextFont: UIFont = { [unowned self] in
        if let font = self.options.selectedTextFont {
            return font
        }
        if let fontSize = self.options.selectedTextFontSize {
            return self.options.bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        }
        return self.font
        }()
    
    fileprivate func tabItemMaxBoundTextHeight() -> CGFloat {
        return _titles.map {
            let mutableAttrString = NSMutableAttributedString(attributedString: $0.tabMenuItemAttributedString)
            mutableAttrString.addAttributes([NSAttributedString.Key.font : self.selectedTextFont], range: mutableAttrString.yy_rangeOfAll())
            return mutableAttrString.bound(for: CGFloat.greatestFiniteMagnitude).height
            }.max() ?? 0
        //        return measureSize("\(_titles.first?.tabMenuItemString.characters.first ?? "国")")// TODO 万一第一个Tab的第一个字符是字母！那高度会不会太小了。。。
    }
    
    // Item的x坐标值
    fileprivate func item_x(_ index: Int) -> CGFloat {
        var marginNeedNum = index
        if options.edgeNeedMargin {
            marginNeedNum += 1
        }
        // 数组的prefix方法表示取出数组的前index个元素
        return _cacheItemWidths.prefix(index).reduce(0, +) + CGFloat(marginNeedNum) * options.margin
    }
    
    // Item对应的scrollBar滚动条的宽度
    fileprivate func scrollBar_width(_ index: Int) -> CGFloat {
        //        return (options.scrollBarWidth < 0 && options.scrollBarWidthPercent > 0) ? _cacheItemWidths[validIndex(index)] * options.scrollBarWidthPercent - options.padding * 2 : options.scrollBarWidth
        return (options.scrollBarWidth < 0 && options.scrollBarWidthPercent > 0) ? _cacheItemWidths[validIndex(index)] * options.scrollBarWidthPercent : options.scrollBarWidth
    }
    
    // Item对应的scrollBar滚动条的x坐标值
    fileprivate func scrollBar_x(_ index: Int) -> CGFloat {
        let itemX = item_x(index)
        switch options.scrollBarLeadingPosition {
        case .center:
            let itemWidth = _cacheItemWidths[validIndex(index)]
            let scrollBarWidth = scrollBar_width(index)
            return itemX + (itemWidth - scrollBarWidth) * 0.5
        case .left:
            return itemX
        }
    }
    
    @objc fileprivate func onItemTapped(_ any: AnyObject?) {
        guard let button = any as? UIButton else {
            return
        }
        guard _switchControl else {
            return
        }
        let tabIndex = button.tag - 999
        if _currentTabIndex != tabIndex {
            let disable = abs(_currentTabIndex - tabIndex) > 1
            delegate?.switchToTab?(tabIndex, disable: disable)
            delegate?.switchToTab?(self, preIndex: _currentTabIndex, newIndex: tabIndex, disable: disable)
        } else {
            delegate?.tappedCurrentFocusedTab?(tabIndex)
            delegate?.tappedCurrentFocusedTab?(self, index: tabIndex)
            updateTextTailIconStateIfNeeded(with: tabIndex)
        }
    }
    
    func scrollToTab(_ tabIndex: Int, animted: Bool = true, invokeDelegate: Bool = true) {
        //        guard _currentTabIndex != tabIndex else {
        //            return
        //        }
        
        if invokeDelegate && _currentTabIndex != tabIndex {
            let disable = abs(_currentTabIndex - tabIndex) > 1
            delegate?.switchToTab?(tabIndex, disable: disable)
            delegate?.switchToTab?(self, preIndex: _currentTabIndex, newIndex: tabIndex, disable: disable)
        }
        
        let toFloat = CGFloat(tabIndex) * ELTabMenuConstant.kScreenWidth
        if animted {
            _switchControl = false
            // 利用CADisplayLink来模拟PageController的contentOffset的变化
            ELTabMenuUtils.share.transition(_currentOffset.x, toFloat: toFloat) {[weak self] (finished, offsetX) in
                self?.contentOffset = CGPoint(x: offsetX, y: 0)
                if finished {
                    // 结束啦！
                    self?.scrollTabToCenter(tabIndex)
                    self?._switchControl = true
                }
            }
        } else {
            contentOffset = CGPoint(x: toFloat, y: 0)
            scrollTabToCenter(tabIndex, animted: false)
        }
    }
    
    func scrollTabToCenter(_ tabIndex: Int, animted: Bool = true) {
        guard let tabItemView = validTabItemButton(tabIndex) else { return }
        // 1.该目标Tab的坐标
        let tabFrame = tabItemView.frame
        let centerX = tabFrame.origin.x + tabFrame.width * 0.5
        var offsetX = centerX - _width * 0.5
        offsetX = min(max(0, _contentView.contentSize.width - _width), max(0, offsetX))
        _contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animted)
    }
    
    fileprivate func validTabItemButton(_ tabIndex: Int) -> UIButton? {
        //        guard tabIndex >= 0 && tabIndex < _tabItemViewArr.count else { return nil }
        //        return _tabItemViewArr[tabIndex] as? UIButton
        let button = _contentView.viewWithTag(tabIndex + 999) as? UIButton
        return button
    }
    
    fileprivate func validIndex(_ index: Int) -> Int {
        return min(_titles.count - 1, max(index, 0))
    }
    
    var contentOffset: CGPoint = CGPoint.zero {
        didSet {
            // TODO 目前没有对只有一个Tab时的处理
            
            // 请保证至少需要两个Tab，不然下面的计算会出问题
            guard _titles.count >= 2 else {
                return
            }
            
            guard options.isScrollBarAutoScrollWithOffsetChanged || !_switchControl else {
                return
            }
            
            _currentOffset = contentOffset
            
            // 假定默认情况下，与之配对的PageController是全屏的
            let allPageContentWidth = CGFloat(_titles.count) * ELTabMenuConstant.kScreenWidth
            // offset的百分比
            let diffPercent = (contentOffset.x + 0.5) / (allPageContentWidth - ELTabMenuConstant.kScreenWidth)
            let multiplied = 1.0 / CGFloat(_titles.count - 1)
            // 根据offset计算当前在哪个Page上
            let currentTabIndex = Int(diffPercent / multiplied)
            _currentTabIndex = currentTabIndex
            //            __devlog("diffPercent \(diffPercent), multiplied \(multiplied), currentTabIndex \(currentTabIndex)")
            
            let multipiedOffset = multiplied * CGFloat(currentTabIndex)
            
            let diffMultipied = diffPercent - multipiedOffset
            let _percent = diffMultipied / multiplied
            //            __devlog("diffMultipied \(diffMultipied), _percent \(_percent)")
            
            let _diffXOffset = scrollBar_x(currentTabIndex + 1) - scrollBar_x(validIndex(currentTabIndex))
            let _diffWidthOffset = scrollBar_width(currentTabIndex + 1) - scrollBar_width(currentTabIndex)
            //            __devlog("_diffXOffset \(_diffXOffset), _diffWidthOffset \(_diffWidthOffset)")
            
            let scrollBarX = scrollBar_x(currentTabIndex)
            let scrollBarWidth = scrollBar_width(currentTabIndex)
            let targetX = scrollBarX + _diffXOffset * _percent
            let targetWidth = scrollBarWidth + _diffWidthOffset * _percent
            
            var frame = scrollBar.frame
            frame.origin.x = targetX
            frame.size.width = targetWidth
            scrollBar.frame = frame
            
            //            print("//////////////////////////////////////////////////////////////////////////")
            //            print("//////////////////////////////////////////////////////////////////////////")
            
            for element in _tabItemViewArr.enumerated() {
                let itemView = element.element
                let offset = element.offset
                
                if diffPercent >= multiplied * (CGFloat(offset - 1) + 0.5) && diffPercent <= multiplied * (CGFloat(offset) + 0.5) {
                    if let button = itemView as? UIButton {
                        if let title = _titles[offset, true] {
                            button.setAttributedTitle(createMutableAttributedString(title: title, tabIndex: offset, currentTabIndex: currentTabIndex, isCurrentTabIndex: true), for: .normal)
                        }
                    }
                } else {
                    if let button = itemView as? UIButton {
                        if let title = _titles[offset, true] {
                            button.setAttributedTitle(createMutableAttributedString(title: title, tabIndex: offset, currentTabIndex: currentTabIndex, isCurrentTabIndex: false), for: .normal)
                        }
                    }
                }
            }
        }
    }
    
}

extension ELTabMenu: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tabMenuScrollViewDelegate?(self)?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.tabMenuScrollViewDelegate?(self)?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.tabMenuScrollViewDelegate?(self)?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.tabMenuScrollViewDelegate?(self)?.scrollViewDidEndDecelerating?(scrollView)
    }
}
extension ELTabMenu {
    class func createHotNewSampleMenu() -> ELTabMenu {
        let tabMenu = ELTabMenu(frame: CGRect(origin: .zero, size: CGSize(width: 136, height: 44)))
        tabMenu.options.normalColor = .subColor // 菜单项未选中时文本的颜色
        tabMenu.options.selectedTextFont = UIFont.systemMediumFont(18)
        tabMenu.options.normalTextFont = UIFont.systemMediumFont(18)
        tabMenu.options.selectedColor = UIColor.colorFF6680 // 菜单项被选中时文本的颜色
        tabMenu.options.edgeNeedMargin = false
        tabMenu.options.padding = 8.0
        tabMenu.options.scrollBarAlpha = 0
        tabMenu.options.margin = 0.0
        tabMenu.isExclusiveTouch = true
        tabMenu.tabTitles = ["最热", "最新"]
        return tabMenu
    }
    
    // 7.9.0 新增样式
    class func createHotNewSampleMenu2() -> ELTabMenu {
        let tabMenu = ELTabMenu(frame: CGRect(origin: .zero, size: CGSize(width: 125, height: 44)))
        
        let scrollBarHeight: CGFloat = 28.0
        let scrollIndicatorView = UIView()
        scrollIndicatorView.backgroundColor = UIColor.colorFF6680.withAlphaComponent(0.1)
        scrollIndicatorView.layer.cornerRadius = scrollBarHeight * 0.5
        scrollIndicatorView.layer.masksToBounds = true
        
        var options = ELTabMenuOptions()
        options.normalColor = .subColor // 菜单项未选中时文本的颜色
        options.selectedColor = UIColor.colorFF6680 // 菜单项被选中时文本的颜色
        options.selectedTextFont = UIFont.systemMediumFont(16)
        options.normalTextFont = UIFont.systemMediumFont(16)
        options.edgeNeedMargin = false
        options.padding = 8
        options.margin = 24.0
        options.scrollBarHeight = CGFloat(scrollBarHeight)
        options.scrollBarPositionOffset = -8.0
        options.scrollIndicatorView = scrollIndicatorView
        tabMenu.options = options
        tabMenu.isExclusiveTouch = true
        tabMenu.tabTitles = ["最热", "最新"]
        
        return tabMenu
    }
}
