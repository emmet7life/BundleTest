//
//  VCFollowButton.swift
//  BundleTest
//
//  Created by jianli chen on 2018/12/24.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class VCFollowButton: UIButton {
    
    // 关注按钮的四种状态
    // 1. following 关注中...
    // 2. followed 已关注
    // 3. unfollowing 取消关注中...
    // 4. unfollow 未关注
    enum VCButtonState {
        case following
        case followed
        case unfollowing
        case unfollow
    }
    
    // 样式
    // 1. normal 普通
    // 2. darkRed 深红色
    enum Style {
        case normal
        case darkRed
        
        var size: CGSize {
            switch self {
            case .normal: return CGSize(width: 60.0, height: 24.0)
            case .darkRed: return CGSize(width: 60.0, height: 30.0)
            }
        }
        
        func bundleName(with state: VCButtonState) -> String {
            let isNormal = self == .normal
            switch state {
            case .followed: return isNormal ? "follow" : "follow_red"
            case .unfollow: return isNormal ? "unfollow" : "unfollow_red"
            case .following: return isNormal ? "followload" : "followload_red"
            case .unfollowing: return isNormal ? "unfollowload" : "unfollowload_red"
            }
        }
    }
    
    private(set) lazy var followingLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: self.currentStyle.bundleName(with: .following))
    }()
    private(set) lazy var unfollowingLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: self.currentStyle.bundleName(with: .unfollowing))
    }()
    private(set) lazy var unfollowLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: self.currentStyle.bundleName(with: .unfollow))
    }()
    private(set) lazy var followedLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: self.currentStyle.bundleName(with: .followed))
    }()
    
    private(set) var currentState: VCButtonState = .unfollow
    private(set) var currentStyle: Style = .normal
    
    private(set) var isFollow: Bool = false
    var isAnimating: Bool {
        return currentState == .following || currentState == .unfollowing
    }
    
    private var _isDidInitialized: Bool = false
    
    // 推荐使用本方法构造，直接传入需要的style样式
    convenience init(style: Style = .normal) {
        self.init(frame: CGRect(origin: .zero, size: style.size))
        currentStyle = style
        _didInitialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _didInitialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !_isDidInitialized {
            _didInitialize()
        }
        backgroundColor = .clear
        followingLottieView?.frame = bounds
        unfollowingLottieView?.frame = bounds
        unfollowLottieView?.frame = bounds
        followedLottieView?.frame = bounds
    }
    
    private func _didInitialize() {
        guard !_isDidInitialized else { return }
        _isDidInitialized = true
        isScaleDownEffectEnable = true
        followingLottieView.isUserInteractionEnabled = false
        unfollowingLottieView.isUserInteractionEnabled = false
        unfollowLottieView.isUserInteractionEnabled = false
        followedLottieView.isUserInteractionEnabled = false
        
        followingLottieView.loopAnimation = true
        unfollowingLottieView.loopAnimation = true
        
        addSubview(followingLottieView)
        addSubview(unfollowingLottieView)
        addSubview(unfollowLottieView)
        addSubview(followedLottieView)
    }
    
    func updateStyle(with style: Style) {
        currentStyle = style
        _removeAll()
        _recreateLottiesView()
        _isDidInitialized = false
        _didInitialize()
        setNeedsLayout()
    }
    
    func startLoading(_ isFollowed: Bool = true, animated: Bool = false, isJudgeAnimating: Bool = false) {
        followStatusChange(state: isFollowed ? .following : .unfollowing, animated: animated, isJudgeAnimating: isJudgeAnimating)
    }
    
    func stopLoading(_ isFollowed: Bool = false, animated: Bool = false, isJudgeAnimating: Bool = false) {
        followStatusChange(state: isFollowed ? .followed : .unfollow, animated: animated, isJudgeAnimating: isJudgeAnimating)
    }
    
    func stopLoadingWithSuccess(_ animated: Bool = true) {
        var state: VCButtonState = .unfollow
        if currentState == .unfollowing {
            state = .unfollow
        } else if currentState == .following {
            state = .followed
        }
        followStatusChange(state: state, animated: animated, isJudgeAnimating: true)
    }
    
    func stopLoadingWithError(_ animated: Bool = false) {
        var state: VCButtonState = .unfollow
        if currentState == .unfollowing {
            state = .followed
        } else if currentState == .following {
            state = .unfollow
        }
        followStatusChange(state: state, animated: animated, isJudgeAnimating: true)
    }
    
    func followStatusChange(isFollowed: Bool, animated: Bool = false, isJudgeAnimating: Bool = false) {
        followStatusChange(state: isFollowed ? .followed : .unfollow, animated: animated, isJudgeAnimating: isJudgeAnimating)
    }
    
    /// 更改关注状态
    ///
    /// - Parameters:
    ///   - isFollowed: 是否关注
    ///   - animeted: 是否执行动画
    ///   - isJudgeAnimating: 执行操作时，是否判断动画正在进行过程中时，动画执行过程中时不执行对应操作
    func followStatusChange(state: VCButtonState, animated: Bool = false, isJudgeAnimating: Bool = false) {
        currentState = state
        switch state {
        case .followed:
            isFollow = true
            _hidden(with: unfollowLottieView)
            _hidden(with: unfollowingLottieView)
            _hidden(with: followingLottieView)
            VCUIUtils.setLottieAnimationView(with: followedLottieView, animated, isJudgeAnimating)
            
        case .following:
            _hidden(with: unfollowLottieView)
            _hidden(with: unfollowingLottieView)
            _hidden(with: followedLottieView)
            VCUIUtils.setLottieAnimationView(with: followingLottieView, animated, isJudgeAnimating)
            
        case .unfollow:
            isFollow = false
            _hidden(with: followedLottieView)
            _hidden(with: followingLottieView)
            _hidden(with: unfollowingLottieView)
            VCUIUtils.setLottieAnimationView(with: unfollowLottieView, animated, isJudgeAnimating)
            
        case .unfollowing:
            _hidden(with: followedLottieView)
            _hidden(with: followingLottieView)
            _hidden(with: unfollowLottieView)
            VCUIUtils.setLottieAnimationView(with: unfollowingLottieView, animated, isJudgeAnimating)
        }
        setNeedsLayout()
    }
    
    func hiddenAll() {
        _hidden(with: followedLottieView)
        _hidden(with: followingLottieView)
        _hidden(with: unfollowLottieView)
        _hidden(with: unfollowingLottieView)
    }
    
    fileprivate func _removeAll() {
        followedLottieView.stop()
        followingLottieView.stop()
        unfollowLottieView.stop()
        unfollowingLottieView.stop()
        
        followedLottieView.removeFromSuperview()
        followingLottieView.removeFromSuperview()
        unfollowLottieView.removeFromSuperview()
        unfollowingLottieView.removeFromSuperview()
    }
    
    fileprivate func _recreateLottiesView() {
        followingLottieView = VCUIUtils.createLottieAnimateView(with: currentStyle.bundleName(with: .following))
        unfollowingLottieView = VCUIUtils.createLottieAnimateView(with: currentStyle.bundleName(with: .unfollowing))
        unfollowLottieView = VCUIUtils.createLottieAnimateView(with: currentStyle.bundleName(with: .unfollow))
        followedLottieView = VCUIUtils.createLottieAnimateView(with: currentStyle.bundleName(with: .followed))
    }
    
    fileprivate func _hidden(with view: LOTAnimationView) {
        view.isHidden = true
        view.stop()
    }
}

class VCUIUtils {
    // 创建Lottie组件
    class func createLottieAnimateView(with bundleName: String) -> LOTAnimationView? {
        if let bundle = Bundle.vc_customBundle(with: bundleName) {
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable] {
                        return LOTAnimationView(json: dataJson, bundle: bundle)
                    }
                }
            }
        }
        return nil
    }
    
    class func setLottieAnimationView(with lottieView: LOTAnimationView, _ animated: Bool, _ isJudgeAnimating: Bool) {
        lottieView.isHidden = false
        if animated {
            if isJudgeAnimating {
                if  !lottieView.isAnimationPlaying {
                    lottieView.play()
                }
            } else {
                lottieView.play()
            }
        } else {
            if isJudgeAnimating {
                if  !lottieView.isAnimationPlaying {
                    lottieView.animationProgress = 1
                }
            } else {
                lottieView.animationProgress = 1
            }
        }
    }
}

private var kScaleDownUIEffectAssociatedObjectKey: Void?
private let kScaleDownUIEffectDefaultEnabled: Bool = false
private let kScaleDownDefaultScaleDownValue: CGFloat = 0.9

extension UIButton {
    
    // 可配置按钮是否开启按下缩小的UI效果，默认不开启
    @IBInspectable public var isScaleDownEffectEnable: Bool {
        get {
            return (objc_getAssociatedObject(self, &kScaleDownUIEffectAssociatedObjectKey) as? Bool) ?? kScaleDownUIEffectDefaultEnabled
        }
        set {
            if newValue {
                adjustsImageWhenHighlighted = false
            } else {
                adjustsImageWhenHighlighted = true
            }
            objc_setAssociatedObject(self, &kScaleDownUIEffectAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isScaleDownEffectEnable {
            self.transform = .identity
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.transform = CGAffineTransform(scaleX: kScaleDownDefaultScaleDownValue, y: kScaleDownDefaultScaleDownValue)
            }) { (_) in
                
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        _resetTransformIfNeeded()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        _resetTransformIfNeeded()
    }
    
    fileprivate func _resetTransformIfNeeded() {
        if isScaleDownEffectEnable {
            UIView.animate(withDuration: 0.16, delay: 0.05, options: .beginFromCurrentState, animations: {
                self.transform = CGAffineTransform.identity
            }) { (_) in
                
            }
        }
    }
}
