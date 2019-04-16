//
//  VCAdvanceLookButton.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/1.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

// 抢先看 Tip & 用户列表 <Lottie组件>
class VCAdvanceLookButton: UIButton {
    
    // 按钮的两种状态
    // 1. initJump 关注中...
    // 2. neonLight 已关注
    enum VCButtonState {
        case initJump       // 初始弹跳
        case neonLight      // 霓虹灯效果
    }
    
    private(set) lazy var initJumpLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: "advance_look_jump_init")
    }()
    private(set) lazy var neonLightLottieView: LOTAnimationView! = {
        return VCUIUtils.createLottieAnimateView(with: "advance_look_scrolling")
    }()
    
    private(set) var currentState: VCButtonState = .initJump
    
    var isAnimating: Bool {
        return currentState == .initJump
    }
    
    private var _isDidInitialized: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _didInitialize()
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
        initJumpLottieView?.frame = bounds
        neonLightLottieView?.frame = bounds
    }
    
    private func _didInitialize() {
        guard !_isDidInitialized else { return }
        _isDidInitialized = true
        isScaleDownEffectEnable = true
        initJumpLottieView.isUserInteractionEnabled = false
        neonLightLottieView.isUserInteractionEnabled = false
        
        initJumpLottieView.loopAnimation = false
        neonLightLottieView.loopAnimation = true
        initJumpLottieView.contentMode = .scaleAspectFit
        neonLightLottieView.contentMode = .scaleAspectFit
        
        addSubview(initJumpLottieView)
        addSubview(neonLightLottieView)
        
        _resetProgress()
    }
    
    private func _resetProgress() {
        initJumpLottieView.animationProgress = 0
        neonLightLottieView.animationProgress = 0
    }
    
    func start(animated: Bool = false, isJudgeAnimating: Bool = false) {
        _resetProgress()
        _statusChange(state: .initJump, animated: animated, isJudgeAnimating: isJudgeAnimating)
    }
    
    func stop(animated: Bool = false, isJudgeAnimating: Bool = false) {
        _statusChange(state: .neonLight, animated: animated, isJudgeAnimating: isJudgeAnimating)
    }
    
    /// 更改状态
    ///
    /// - Parameters:
    ///   - state: 状态
    ///   - animeted: 是否执行动画
    ///   - isJudgeAnimating: 执行操作时，是否判断动画正在进行过程中时，动画执行过程中时不执行对应操作
    private func _statusChange(state: VCAdvanceLookButton.VCButtonState, animated: Bool = false, isJudgeAnimating: Bool = false) {
        currentState = state
        switch state {
        case .initJump:
            _hidden(with: neonLightLottieView)
            initJumpLottieView.completionBlock = nil
            initJumpLottieView.completionBlock = {[weak self] (animationFinished) in
                self?._statusChange(state: .neonLight, animated: animated, isJudgeAnimating: isJudgeAnimating)
            }
            VCUIUtils.setLottieAnimationView(with: initJumpLottieView, animated, isJudgeAnimating)
            
        case .neonLight:
            _hidden(with: initJumpLottieView)
            VCUIUtils.setLottieAnimationView(with: neonLightLottieView, animated, isJudgeAnimating)
        }
        setNeedsLayout()
    }
    
    fileprivate func _hidden(with view: LOTAnimationView) {
        view.isHidden = true
        view.stop()
    }
}

