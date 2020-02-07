//
//  VCSignBoxView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/10.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCSignBoxView: VCLoadFromNibBaseView {
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var boxImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var _isDeinit = false
    private var _isStarAnimating = false
    private var _preAnimView: UIView? = nil
    
    @IBAction func onMainViewTapped(_ sender: Any) {
        edgeToCenterAnimation()
    }
    
    override func initialize() {
        startStarAnimation()
    }
    
    deinit {
        _isDeinit = true
    }
    
    private func shakeAnimation(with view: UIView) {
        view.shake(5, withDelta: 45, speed: 0.07, shakeDirection: ShakeDirection.rotation) { [weak self] in
            guard let stongSelf = self else { return }
            delay(0.36, callFunc: { [weak stongSelf] in
                guard let weakSelf = stongSelf else { return }
                view.shake(6, withDelta: 65, speed: 0.06, shakeDirection: ShakeDirection.rotation) { [weak weakSelf] in
                    weakSelf?.onShakeAnimationComplete()
                }
            })
        }
    }
    
    private func onShakeAnimationComplete() {
        
    }
    
    func startStarAnimation() {
        guard !_isDeinit else { return }
        guard !_isStarAnimating else { return }
        _isStarAnimating = true
        let duration: TimeInterval = 0.46
        let offset: TimeInterval = 0.06
        _starAnimation(with: star1ImageView, duration: duration, timeOffset: 0)
        _starAnimation(with: star2ImageView, duration: duration, timeOffset: duration - offset)
        _starAnimation(with: star3ImageView, duration: duration, timeOffset: 2 * (duration - offset))
    }

    private func _starAnimation(with view: UIView, duration: TimeInterval, timeOffset: TimeInterval = 0) {
        guard !_isDeinit else { return }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.beginTime = CACurrentMediaTime() + timeOffset
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.fillMode = CAMediaTimingFillMode.removed
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        animation.setValue(view, forKey: "star_anim_view")
        view.layer.add(animation, forKey: "opacity_anim")
    }
    
    func edgeToCenterAnimation() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let frame = boxImageView.convertRectToWindow()
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.68)
        contentView.layer.opacity = 0.0
        contentView.frame = window.bounds
        window.addSubview(contentView)
        
        let backgroundViewWidth = window.width - 16.0 * 2
        let backgroundView = UIImageView(image: UIImage(named: "合并形状"))
        backgroundView.size = CGSize(width: backgroundViewWidth, height: backgroundViewWidth)
        backgroundView.contentMode = .scaleAspectFit
        backgroundView.center = contentView.center
        backgroundView.layer.opacity = 0.0
        window.addSubview(backgroundView)
        
        let animateView = UIImageView(frame: frame)
        animateView.contentMode = boxImageView.contentMode
        animateView.image = boxImageView.image
        window.addSubview(animateView)
        
        star1ImageView.isHidden = true
        star2ImageView.isHidden = true
        star3ImageView.isHidden = true
        boxImageView.isHidden = true
        timeLabel.isHidden = true
        
        // animateView animation
        let startPoint = animateView.center
        let endPoint = window.center
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [startPoint, endPoint]
        positionAnimation.keyTimes = [0.0, 1.0]
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let scaleAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1.0, 1.68, 1.88]
        scaleAnimation.keyTimes = [0.0, 0.88, 1.0]
        
        let groupAnimDuration: TimeInterval = 0.5
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, scaleAnimation]
        groupAnimation.duration = groupAnimDuration
        groupAnimation.beginTime = CACurrentMediaTime()
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.delegate = self
        
        groupAnimation.setValue(animateView, forKey: "edgeToCenterAnimateView")
        animateView.layer.add(groupAnimation, forKey: "edgeToCenterAnimation")
        
        // contentView animation
        let durationRadio: TimeInterval = 0.2
        let opacityAnimation = _createOpacityAnimation(beginTime: CACurrentMediaTime() + groupAnimDuration * (1.0 - durationRadio),
                                                       duration: groupAnimDuration * durationRadio)
        opacityAnimation.setValue(contentView, forKey: "contentView")
        contentView.layer.add(opacityAnimation, forKey: "opacityAnimation")
        
        // backgroundView animation
        let durationRadio2: TimeInterval = 0.3
        let opacityAnimation2 = _createOpacityAnimation(from: 0.0, to: 0.68,
                                                        beginTime: CACurrentMediaTime() + groupAnimDuration * (1.0 - durationRadio2),
                                                        duration: groupAnimDuration * durationRadio2)
        
        let rotationAnmation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotationAnmation.values = [0.0, Double.pi]
        rotationAnmation.keyTimes = [0.0, 1.0]
        rotationAnmation.duration = 3.0
        rotationAnmation.repeatCount = Float.infinity
        rotationAnmation.beginTime = CACurrentMediaTime() + groupAnimDuration
        rotationAnmation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnmation.isRemovedOnCompletion = false
        rotationAnmation.delegate = self
        
        backgroundView.layer.add(rotationAnmation, forKey: "backgroundView")
        backgroundView.layer.add(opacityAnimation2, forKey: "opacityAnimation2")
    }
    
    private func _createOpacityAnimation(from fromValue: CGFloat = 0.0, to toValue: CGFloat = 1.0,
                                         beginTime: CFTimeInterval = CACurrentMediaTime(), duration: CFTimeInterval) -> CAAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.repeatCount = 1
        opacityAnimation.autoreverses = false
        opacityAnimation.beginTime = beginTime
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.delegate = self
        return opacityAnimation
    }
}

extension VCSignBoxView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let view = anim.value(forKey: "star_anim_view") as? UIView {
            view.layer.removeAnimation(forKey: "opacity_anim")
            if view == star3ImageView {
                _isStarAnimating = false
                startStarAnimation()
            }
        } else if let view = anim.value(forKey: "edgeToCenterAnimateView") as? UIView {
            delay(0.36) { [weak self] in
                self?.shakeAnimation(with: view)
            }
        }
    }
}
