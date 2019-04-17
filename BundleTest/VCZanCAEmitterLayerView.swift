//
//  VCZanCAEmitterLayerView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/17.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

extension CGPoint {
    var toInt: CGPoint {
        return CGPoint(x: Int(x), y: Int(y))
    }
}

class VCZanCAEmitterLayerView: VCLoadFromNibBaseView {

    // MARK: - View
    @IBOutlet var contentView: UIView!
    
    struct CachedPath {
        var path: UIBezierPath
        var startPoint: CGPoint
        var controlPoint: CGPoint
        var endPoint: CGPoint
    }
    private var _cachedBezierPaths: [CachedPath] = []
    
    private var emitterLayer: CALayer {
        return contentView.layer
    }
    
    override func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("🖌draw rect🖌")
        
        for path in _cachedBezierPaths {
            print("\(path.startPoint.toInt) - \(path.endPoint.toInt) : \(path.controlPoint.toInt)")
            
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: path.startPoint.toInt, size: CGSize(width: 4, height: 4)))
            
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: path.endPoint.toInt, size: CGSize(width: 4, height: 4)))
            
            UIColor.yellow.setFill()
            UIRectFill(CGRect(origin: path.controlPoint.toInt, size: CGSize(width: 4, height: 4)))
            
            UIColor.red.set()
            path.path.lineWidth = 1.0
            path.path.lineCapStyle = CGLineCap.round
            path.path.lineJoinStyle = CGLineJoin.round
            path.path.stroke()
        }
    }
    
    private func createEmitterLayer(with icon: String) -> CALayer? {
        guard let image = UIImage(named: icon) else { return nil }
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        layer.position = contentView.center
        layer.contents = image.cgImage
        layer.contentsScale = UIScreen.main.nativeScale
        return layer
    }
    
    func fire() {
        var layers: [CALayer] = []
        for _ in 0 ..< 2 {
            let iconNo = arc4random_uniform(10)
            print("🌹 图片iconNo: \(iconNo)")
            if let layer = createEmitterLayer(with: "emoji_1f60\(iconNo)") {
                layers.append(layer)
                emitterLayer.addSublayer(layer)
            }
        }
        
        print("🌹 有效个数: \(layers.count)")
        
        _cachedBezierPaths.removeAll()
        
//        let radius = width * 0.5
        for layer in layers {
            let random = max(2, arc4random_uniform(10))
            let direction: CGFloat = random % 2 == 0 ? 1.0 : -1.0
            let percent = CGFloat(random) / 10.0
            let offsetX = width * 0.5 * percent * direction
            let offsetY = height * 0.5 * percent * -1.0
            
            print("random: \(random)|direction: \(direction)|percent: \(percent)|offsetX: \(offsetX)|offsetY: \(offsetY)")
            
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            let startPoint = layer.position
            let endPoint = CGPoint(x: startPoint.x + offsetX, y: startPoint.y + offsetY)
            positionAnimation.values = [startPoint, endPoint]
            positionAnimation.keyTimes = [0.0, 1.0]
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let controlPointX = offsetX > 0 ? startPoint.x + offsetX * 0.8 : startPoint.x + offsetX * 0.8
            let controlPointY = endPoint.y + offsetY * 0.2
            let controlPoint = CGPoint(x: controlPointX, y: controlPointY)
            let bezierPath = UIBezierPath()
            bezierPath.move(to: startPoint)
            bezierPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
            _cachedBezierPaths.append(CachedPath(path: bezierPath, startPoint: startPoint, controlPoint: controlPoint, endPoint: endPoint))
            positionAnimation.path = bezierPath.cgPath
            
            let alphaAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
            alphaAnimation.values = [0.9, 1.0, 0.0]
            alphaAnimation.keyTimes = [0.0, 0.6, 1.0]
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnimation, alphaAnimation]
            groupAnimation.duration = 1.0
            groupAnimation.isRemovedOnCompletion = true
            groupAnimation.delegate = self
            
            groupAnimation.setValue(layer, forKey: "layerName")
            layer.add(groupAnimation, forKey: "groupAnimation")
        }
        
        setNeedsDisplay()
    }
    
    func stop() {
        
    }
}

extension VCZanCAEmitterLayerView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animationLayer = anim.value(forKey: "layerName") as? CALayer {
            animationLayer.removeAnimation(forKey: "groupAnimation")
            animationLayer.removeFromSuperlayer()
        }
    }
}
