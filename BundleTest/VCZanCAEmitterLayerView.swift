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
    
    struct LayerWrapper {
        var layer: CALayer
        var angle: CGFloat
    }
    
    private var emitterLayer: CALayer {
        return contentView.layer
    }
    
    private var _angles: [CGFloat] = [30, 60, 90, 120, 150, 180]
    
    override func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
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
    
    private func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (angle * CGFloat.pi) / 180
    }
    
    private var random: UInt32 {
        return max(1, arc4random_uniform(10))
    }
    
    func fire() {
        var wrappers: [LayerWrapper] = []
        
        for i in 0 ..< 6 {
            let iconNo = arc4random_uniform(10)
            print("🌹 图片iconNo: \(iconNo)")
            if let layer = createEmitterLayer(with: "emoji_1f60\(iconNo)") {
                emitterLayer.addSublayer(layer)
                let wrapper = LayerWrapper(layer: layer, angle: _angles[i % _angles.count])
                wrappers.append(wrapper)
            }
        }
        
        print("🌹 有效个数: \(wrappers.count)")
        
        _cachedBezierPaths.removeAll()
        
        let radius = width * 0.5
        for wrapper in wrappers {
            print("🐛 角度  \(wrapper.angle)")
            let layer = wrapper.layer
            // 每个象限范围内的可配置的最大x和y
            let rangeInsideMaxX = radius * sin(degreesToRadians(wrapper.angle))
            let rangeInsideMaxY = radius * cos(degreesToRadians(wrapper.angle))
            // 随机百分比
            let randomX = random
            let randomY = random
            let percentX = CGFloat(randomX) / 10.0
            let percentY = CGFloat(randomY) / 10.0
            // 随机坐标
            let targetX = rangeInsideMaxX * percentX
            let targetY = rangeInsideMaxY * percentY
            // 正切值
            let targetTan = targetY / targetX
            // 角度
            let targetAngle = atan(targetTan)
            // 半径方向延伸或收缩的值
            let direction: CGFloat = random % 2 == 0 ? 1.0 : -1.0
            let radiusOffset: CGFloat = CGFloat(random) / 10.0 * 100.0
            // 求偏移的x和y
            let offsetX = radiusOffset * sin(degreesToRadians(targetAngle))
            let offsetY = radiusOffset * cos(degreesToRadians(targetAngle))
            // 最终值
            let finalX = targetX + (offsetX * direction)
            let finalY = targetY + (offsetY * direction)
//            print("random: \(random)|direction: \(direction)|percent: \(percent)|offsetX: \(offsetX)|offsetY: \(offsetY)")
            
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            let startPoint = layer.position
            let endPoint = CGPoint(x: finalX, y: finalY)
            // 起始坐标和最终坐标的x、y偏移
            let startToEndOffsetX = endPoint.x - startPoint.x
            let startToEndOffsetY = endPoint.y - startPoint.y
            
            // 动画配置
            positionAnimation.values = [startPoint, endPoint]
            positionAnimation.keyTimes = [0.0, 1.0]
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let controlPointX = startPoint.x + startToEndOffsetX * 0.8
            let controlPointY = endPoint.y + startToEndOffsetY * 0.2
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
