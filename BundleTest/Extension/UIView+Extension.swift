//
//  UIView+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/10.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

extension UIView {
    func vc_spring(scale x: CGFloat = 1.36,
                y: CGFloat = 1.15,
                durationPrev: TimeInterval = 0.1168,
                durationNext: TimeInterval = 0.36,
                dampingRatio: CGFloat = 0.168,
                velocity: CGFloat = 16.8,
                options: UIView.AnimationOptions = [.beginFromCurrentState ,.curveEaseInOut],
                animations: (() -> Void)? = nil,
                completion: ((Bool) -> Void)? = nil) {
        vc_animate(withDuration: durationPrev,
                durationNext: durationNext,
                dampingRatio: dampingRatio,
                velocity: velocity,
                options: options,
                animationsPrev: { [weak self] in
                    animations?()
                    self?.transform = CGAffineTransform(scaleX: x, y: y)
                },
                animationsNext: { [weak self] in
                self?.transform = CGAffineTransform.identity
        }) { (isFinished) in
            completion?(isFinished)
        }
    }
    
    func vc_animate(withDuration durationPrev: TimeInterval,
                 durationNext: TimeInterval,
                 dampingRatio: CGFloat,
                 velocity: CGFloat,
                 options: UIView.AnimationOptions = [],
                 animationsPrev: (() -> Void)? = nil,
                 animationsNext: (() -> Void)? = nil,
                 completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: durationPrev) {
            animationsPrev?()
        }
        
        UIView.animate(withDuration: durationNext,
                       delay: durationPrev,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: velocity,
                       options: options,
                       animations: {
                        animationsNext?()
        }) { (isFinished) in
            completion?(isFinished)
        }
    }
}

extension UIView {
    public func setViewCorner(view: UIView, cornerRadius: CGFloat) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
    }
}

