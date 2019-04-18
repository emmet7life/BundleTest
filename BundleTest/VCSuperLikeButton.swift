//
//  VCSuperLikeButton.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import YYText

protocol VCZanItemDataProtocol: class {
    var isZaned: Bool { get set }
    var zanNum: Int { get set }
    var interfacedZanNum: Int { get set }
    var visibleText: String { get }
    var isZanNumUpdated: Bool { get set }
    func resetZanOperatorRelaProperties()
}

extension VCZanItemDataProtocol {
    // 赞
    func increaseZanNum() {
        interfacedZanNum += 1
        zanNum = max(0, zanNum + 1)
        isZanNumUpdated = true
    }
    
    // 取消赞
    func decreaseZanNum() {
        interfacedZanNum = 0
        zanNum = max(0, zanNum - 1)
        isZanNumUpdated = true
    }
}

extension UIView {
    private func _superview(_ view: UIView?) -> UIView? {
        return view?.superview
    }
    
    func convertRectToWindow() -> CGRect {
        guard let superview = _superview(self) else { return CGRect.zero }
        
        var recursiveView: UIView = superview
        var rect: CGRect = self.frame
        
        while let superview = _superview(recursiveView) {
            let rect1 = recursiveView.convert(rect, to: superview)
            recursiveView = superview
            rect = rect1
        }
        
        return rect
    }
}

class VCSuperLikeButton: VCLoadFromNibBaseView {
    
    enum VCLayoutDirection {
        case leading
        case trailing
    }
    
    // MARK: - Option
    struct LayoutOption {
        var isDebug: Bool = true
        var layoutDirection: VCLayoutDirection = .leading
        var directionLeadingPadding: CGFloat = 8.0
        var directionTrailingPadding: CGFloat = 8.0
        var iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
        var iconPaddingToText: CGFloat = 8.0
        var isFixedWidth: Bool = true
        var animateLabelOptions: VCSimpleAnimateLabel.Options = VCSimpleAnimateLabel.Options()
        var adjustNumberTextWidthForVisualStable: Bool = true
    }
    
    // MARK: - View
    private(set) var praiseImageView: UIImageView = UIImageView()
    private(set) var praisedImageView: UIImageView = UIImageView()
    private(set) var praiseLabel: VCSimpleAnimateLabel = VCSimpleAnimateLabel()
    @IBOutlet var contentView: UIView!
    
    // MARK: - Data
    var options = LayoutOption() {
        didSet {
            
        }
    }
    
    private(set) var itemData: VCZanItemDataProtocol? = nil
    
    enum VCActionTriggerReason {
        case quickTapping(UInt, Int)        // 快速点击进行中
        case quickTappedFired                // 快速点击停止，应触发网络事件
        case longPressFiredStart(Int)             // 长按事件开始
        case longPressFiring(Int)                   // 长按事件进行中
        case longPressFingerTouchUp          // 长按事件手指松开
        case longPressFireEnded(Int)            // 长按事件结束
        
        var flagString: String {
            switch self {
            case .quickTapping(_, let count): return "👆1️⃣quickTapping with \(count)"
            case .quickTappedFired: return "👆2️⃣quickTappedFired"
            case .longPressFiredStart(let count): return "✋3️⃣longPressFiredStart with \(count)"
            case .longPressFiring(let count): return "✋4️⃣longPressFiring with \(count)"
            case .longPressFingerTouchUp: return "✋5️⃣longPressFingerTouchUp"
            case .longPressFireEnded(let count): return "✋6️⃣longPressFireEnded with \(count)"
            }
        }
    }
    
    var userTappedActionBlock: ((VCActionTriggerReason) -> Void)? = nil
    
    // MARK: - Func API
    @discardableResult
    func setText(with text: String, isUp: Bool, animated: Bool) -> CGFloat {
        return praiseLabel.setText(with: text, isUp: isUp, animated: animated)
    }
    
    @discardableResult
    func setItemData(with data: VCZanItemDataProtocol, animated: Bool = false) -> CGFloat {
        itemData = data
        let newWidth = _layout(with: data, animated: animated)
        _updatePraiseImage(with: data.isZaned, animated)
        return newWidth
    }
    
    private var _cachedNumberTextVisualWidths: [String: CGFloat] = [:]
    
    private func _getNumberTextVisualWidth(with text: String) -> CGFloat {
        if let cachedWidth = _cachedNumberTextVisualWidths[text] {
            return cachedWidth
        }
        let meatureWidth = praiseLabel.meatureTextWidth(with: text)
        _cachedNumberTextVisualWidths[text] = meatureWidth
        return meatureWidth
    }
    
    @discardableResult
    fileprivate func _layout(with data: VCZanItemDataProtocol, animated: Bool = false) -> CGFloat {
        praiseImageView.size = options.iconSize
        praiseLabel.height = contentView.height
        var textWidth = setText(with: data.visibleText, isUp: data.isZaned, animated: animated)
        
        if options.adjustNumberTextWidthForVisualStable {
            // 纯粹的只显示数字
            if data.visibleText == String(data.zanNum) {
                let count = data.visibleText.count
                textWidth = _getNumberTextVisualWidth(with: Array(repeating: "9", count: count).reduce("", +))
            }
        }
        
        praiseLabel.width = textWidth
        let totalMeaturedWidth = _horizontalPadding + praiseImageView.width + options.iconPaddingToText + praiseLabel.width
        var frameWidth = contentView.width
        if !options.isFixedWidth {
            frameWidth = totalMeaturedWidth
        }
        
        switch options.layoutDirection {
        case .leading:
            praiseImageView.left = options.directionLeadingPadding
            praiseLabel.left = praiseImageView.right + options.iconPaddingToText
            
        case .trailing:
            praiseLabel.right = frameWidth - options.directionTrailingPadding
            if textWidth > 0 {
                praiseImageView.right = praiseLabel.left - options.iconPaddingToText
            } else {
                praiseImageView.right = praiseLabel.left
            }
        }
        
        return frameWidth
    }
    
    // MARK: - Layout
    fileprivate var _horizontalPadding: CGFloat {
        return options.directionLeadingPadding + options.directionTrailingPadding
    }
    
    override func initialize() {
        
        if options.isDebug {
            backgroundColor = .yellow
            contentView.layer.borderColor = UIColor.black.cgColor
            contentView.layer.borderWidth = 0.5
            
            praiseImageView.layer.borderColor = UIColor.red.cgColor
            praiseImageView.layer.borderWidth = 0.5
            
            praiseLabel.layer.borderColor = UIColor.green.cgColor
            praiseLabel.layer.borderWidth = 0.5
        }
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        praiseImageView.clipsToBounds = false
        praiseImageView.image = UIImage(named: "ic_topic_like")
        contentView.addSubview(praiseImageView)
        
        praisedImageView.image = UIImage(named: "ic_topic_liked")
        praiseImageView.addSubview(praisedImageView)
        
        praiseLabel.height = contentView.height
        praiseLabel.contentView.isUserInteractionEnabled = false
        contentView.addSubview(praiseLabel)
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        contentView.addGestureRecognizer(gesture)
    }
    
//    @objc fileprivate func tapGestureAction(_ gesture: UITapGestureRecognizer) {
//        userTappedActionBlock?()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        praiseImageView.centerY = contentView.centerY
        // 确保praisedImageView被praiseImageView包围着
        praisedImageView.frame = praiseImageView.bounds
        praiseLabel.height = contentView.height
    }
    
    // MARK: - Touch Event Handler
    
    private var _touchesEndTime: TimeInterval = 0
    // 一轮触摸事件最开始的赞状态
    private var _touchesBeginZanState: Bool? = nil
    // 任务是否有效
    private var _isTaskValid: Bool {
        // 初始状态有值 并且 任务未处理
        return _touchesBeginZanState != nil && !_isEventHandled
    }
    // 单任务内，快速点击的次数
    private var _quickTappedCount: UInt = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan~~~~")
        if let data = itemData {
            if _isEventHandled && _touchesBeginZanState == nil {
                // 1. 赋初始值
                _isEventHandled = false
                _touchesBeginZanState = data.isZaned
            } else {
                
            }
            if _isTaskValid {
                // 2. 清除Event Handler Timer
                endEventHandlerTimer()
            }
        }
        _longPressDetected = false
        if touches.first != nil {
            startLongPressDetectTimer()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded~~~~1")
        defer {
            endLongPressDetectTimer()
        }
        
        guard !_longPressDetected else {
            print("touchesEnded~~~~长按事件，手指松开")
            // 长按事件，手指松开
            longPressTouchesEnded()
            return
        }
        
        if _isLongPressEventTrigger {
            // 上一次是长按事件，并且未结束，然后再次快速点击时，_quickTappedCount + 3
            _quickTappedCount += 3
            _isLongPressEventTrigger = false
            endEventHandlerTimer()
        }
        
        if let data = itemData, _isTaskValid {
            _quickTappedCount += 1
            // 两种情况下，数据直接反转并同步刷新UI
            if let touchesBeginZanState = _touchesBeginZanState {
                
                // 1. 第一次触摸时，处于已赞状态
                // 1.1 第一次快速点击时，属取消赞操作，应反转数据
                // 1.2 第二次快速点击时，属赞操作，应反转数据
                // 2.3 第三次及之后的快速点击操作，一律认为是赞操作，不应反转
                
                // 2. 第一次触摸时，处于未赞状态
                // 2.1 第一次快速点击时，属赞操作，应反转数据
                // 2.2 第二次及之后的快速点击操作，一律认为是赞操作，不应反转
                
                let state1 = touchesBeginZanState && _quickTappedCount <= 2
                let state2 = !touchesBeginZanState && _quickTappedCount <= 1
                if state1 || state2 {
                    data.isZaned = !data.isZaned
                    data.isZaned ? data.increaseZanNum() : data.decreaseZanNum()
                    setText(with: data.visibleText, isUp: data.isZaned, animated: true)
                    print("touchesEnded~~~~反转数据并刷新UI \(data.isZaned) \(data.zanNum)")
                    _updatePraiseImage(with: data.isZaned, true)
                } else {
                    // 不停的从1.0->1.5->1.0->1.5...
                    data.interfacedZanNum += 1
                    _repeatCurveAnimation(with: praisedImageView)
                }
            }
            userTappedActionBlock?(.quickTapping(_quickTappedCount, data.interfacedZanNum))
            // 2. 网络请求任务不立即执行，延迟一定时间，交给Timer执行
            startEventHandlerTimer(with: 0.50, userInfo: false)
        }
        print("touchesEnded~~~~2")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled~~~~")
        endLongPressDetectTimer()
        endEventHandlerTimer()
        resetInnerControlProperties()
    }
    
    // MARK: - Long Press Detect Timer
    private var _longPressDetectTimer: Timer?
    private var _longPressDetected: Bool = false
    private var _isLongPressEventTrigger: Bool = false
    private var _longPressFiringTimer: SwiftTimer? = nil
    
    private func startLongPressDetectTimer() {
        print("🔥startLongPressDetectTimer~~~~长按事件监测-Timer开始")
        _longPressDetectTimer?.invalidate()
        _longPressDetectTimer = Timer(timeInterval: 0.36, target: self, selector: #selector(longPressDetectTimerFire), userInfo: nil, repeats: false)
        RunLoop.main.add(_longPressDetectTimer!, forMode: RunLoop.Mode.commonModes)
    }
    
    private func endLongPressDetectTimer() {
        print("🔥startLongPressDetectTimer~~~~长按事件监测-Timer取消")
        _longPressDetectTimer?.invalidate()
        _longPressDetectTimer = nil
    }
    
    @objc private func longPressDetectTimerFire() {
        print("🔥longPressDetectTimerFire~~~~长按事件监测-Timer触发")
        // End Timer
        _longPressDetected = true
        endLongPressDetectTimer()
        // Handle Data
        if let data = itemData, _isTaskValid {
            // 两种情况下，数据直接反转并同步刷新UI
            if let touchesBeginZanState = _touchesBeginZanState {
                let state1 = touchesBeginZanState && _quickTappedCount == 1
                let state2 = !touchesBeginZanState && _quickTappedCount == 0
                if state1 || state2 {
                    data.isZaned = true
                    data.increaseZanNum()
                    setText(with: data.visibleText, isUp: data.isZaned, animated: true)
                    print("longPressDetectTimerFire~~~~反转数据并刷新UI \(data.isZaned) \(data.zanNum)")
                    _updatePraiseImage(with: data.isZaned, true)
                } else {
                    itemData?.interfacedZanNum += 1
                }
            }
        }
        // Start Curve Animation
        _startLongPressRepeatCurveAnimation()
        // Fire Block
        userTappedActionBlock?(.longPressFiredStart(itemData?.interfacedZanNum ?? 0))
        // Start Firing Timer
        _longPressFiringTimer = SwiftTimer.repeaticTimer(interval: .milliseconds(100)) { [weak self] (timer) in
            guard let strongSelf = self else { return }
            if let data = strongSelf.itemData {
                data.interfacedZanNum += 1
                strongSelf.userTappedActionBlock?(.longPressFiring(data.interfacedZanNum))
            }
        }
        _longPressFiringTimer?.start()
    }
    
    private func longPressTouchesEnded() {
        // Mark
        _longPressDetected = false
        // Remove Animation
        praisedImageView.layer.removeAllAnimations()
        // Invalidate Firing Timer
        invalidateLongPressFiringTimer()
        // Fire Block
        userTappedActionBlock?(.longPressFingerTouchUp)
        // Start Event Timer
        startEventHandlerTimer(with: 0.50, userInfo: true)
        _isLongPressEventTrigger = true
    }
    
    private func _startLongPressRepeatCurveAnimation() {
        _repeatCurveAnimation(with: praisedImageView, completion: _longPressRepeatCurveAnimationBlock)
    }
    
    private func _longPressRepeatCurveAnimationBlock(_ isFinished: Bool) {
        if isFinished && _longPressDetected {
            _startLongPressRepeatCurveAnimation()
        }
    }
    
    private func invalidateLongPressFiringTimer() {
        _longPressFiringTimer?.suspend()
        _longPressFiringTimer = nil
    }
    
    // MARK: - Event Handler Timer
    private var _eventHandlerTimer: Timer?
    private var _isEventHandled: Bool = true
    
    private func startEventHandlerTimer(with timeInterval: TimeInterval = 0.50, userInfo: Any? = nil) {
        print("⚡️startEventHandlerTimer~~~~延迟网络请求操作-Timer开始")
        _eventHandlerTimer?.invalidate()
        _eventHandlerTimer = nil
        
        _eventHandlerTimer = Timer(timeInterval: timeInterval, target: self, selector: #selector(eventHandlerTimerFire), userInfo: userInfo, repeats: false)
        RunLoop.main.add(_eventHandlerTimer!, forMode: RunLoop.Mode.commonModes)
    }
    
    private func endEventHandlerTimer() {
        print("⚡️endEventHandlerTimer~~~~延迟网络请求操作-Timer取消")
        _eventHandlerTimer?.invalidate()
        _eventHandlerTimer = nil
    }
    
    @objc private func eventHandlerTimerFire() {
        print("⚡️startEventHandlerTimer~~~~延迟网络请求操作-Timer触发")
        if let validTimer = _eventHandlerTimer, validTimer.isValid {
            // 是否是长按触发的操作
            if let isFiredByLongPress = validTimer.userInfo as? Bool {
                if isFiredByLongPress {
                    userTappedActionBlock?(.longPressFireEnded(itemData?.interfacedZanNum ?? 0))
                } else {
                    userTappedActionBlock?(.quickTappedFired)
                }
            }
        }
        endEventHandlerTimer()
        resetInnerControlProperties()
        print("处理了事件~~~~")
    }
    
    private func resetInnerControlProperties() {
        print("☠️💣resetInnerControlProperties~~~~重置参数💣☠️")
        _quickTappedCount = 0
        _isEventHandled = true
        _touchesBeginZanState = nil
        _isLongPressEventTrigger = false
    }
    
    deinit {
        // 任务触发了，但是由于执行时间未到，就被回收了（可能是退出了Controller），此时应手动立即触发
        if _isTaskValid {
            eventHandlerTimerFire()
        } else {
            endEventHandlerTimer()
        }
        endLongPressDetectTimer()
        invalidateLongPressFiringTimer()
    }
    
    // MARK: - Animate
    private var _isAnimatingToInvisible = false
    private var _isAnimatingToVisible = false
    
    private func _updatePraiseImage(with isLike: Bool, _ animated: Bool = false) {
        print("update praise icon isLike(\(isLike)) animated(\(animated)) _isAnimatingToVisible(\(_isAnimatingToVisible)) _isAnimatingToInvisible(\(_isAnimatingToInvisible))")
        let zanView = praisedImageView
        zanView.layer.removeAllAnimations()
        if isLike {
            guard animated else {
                if !_isAnimatingToVisible {
                    zanView.alpha = 1.0
                    zanView.transform = CGAffineTransform.identity
                }
                _isAnimatingToVisible = false
                print("update praise icon return 1")
                return
            }
            guard !_isAnimatingToVisible else {
                print("update praise icon return 2")
                return
            }
            _isAnimatingToVisible = true
            zanView.alpha = 1.0
            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.alpha = 1.0
                            zanView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.36,
                           delay: 0.30,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.alpha = 1.0
                            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { [weak self] (isFinished) in
                print("update praise icon completion 1.0 \(isFinished)")
                self?._isAnimatingToVisible = false
                if isFinished {
                    zanView.alpha = 1.0
                    zanView.transform = CGAffineTransform.identity
                }
            })
        } else {
            guard animated else {
                if !_isAnimatingToInvisible {
                    zanView.alpha = 0.0
                    zanView.transform = CGAffineTransform.identity
                }
                _isAnimatingToInvisible = false
                print("update praise icon return 3")
                return
            }
            guard !_isAnimatingToInvisible else {
                print("update praise icon return 4")
                return
            }
            _isAnimatingToInvisible = true
            zanView.alpha = 1.0
            zanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.36,
                           delay: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            zanView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { [weak self] (isFinished) in
                print("update praise icon completion 0.0 \(isFinished)")
                self?._isAnimatingToInvisible = false
                if isFinished {
                    zanView.alpha = 0.0
                    zanView.transform = CGAffineTransform.identity
                }
            })
        }
    }
    
    typealias CurveAnimationCompletionBlock = (Bool) -> Void
    private var _curveAnimationCompletionBlocks: [CurveAnimationCompletionBlock] = []
    
    private var _isRepeatCurveAnimating: Bool = false
    private func _repeatCurveAnimation(with view: UIView, completion: CurveAnimationCompletionBlock? = nil) {
        if let block = completion {
            _curveAnimationCompletionBlocks.append(block)
        }
        guard !_isRepeatCurveAnimating else {
            return
        }
        _isRepeatCurveAnimating = true
        view.layer.removeAllAnimations()
        view.alpha = 1.0
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.26,
                       delay: 0.0,
                       options: .beginFromCurrentState,
                       animations: {
                        view.alpha = 1.0
                        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.26,
                       delay: 0.30,
                       options: .beginFromCurrentState,
                       animations: {
                        view.alpha = 1.0
                        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { [weak self] (isFinished) in
            self?._isRepeatCurveAnimating = false
            if isFinished {
                view.alpha = 1.0
                view.transform = CGAffineTransform.identity
            }
            if let strongSelf = self {
                let blocks = strongSelf._curveAnimationCompletionBlocks
                strongSelf._curveAnimationCompletionBlocks.removeAll()
                blocks.forEach { $0(isFinished) }
            }
            
        })
    }
    
}

