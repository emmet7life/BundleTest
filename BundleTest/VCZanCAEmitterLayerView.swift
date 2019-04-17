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
        var xCosAngle: CGFloat
        var yTanAngle: CGFloat
    }
    
    private var emitterLayer: CALayer {
        return contentView.layer
    }
    
    private var _xCosAngles: [CGFloat] = [0, 30, 60, 120, 150, 180]
    private var _yTanAngles: [CGFloat] = [30, 60, 60, 120, 150, 180]
    
    override func initialize() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        emitterLayer.addSublayer(_numberLayer)
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
        layer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        layer.position = contentView.center
        layer.contents = image.cgImage
        layer.contentsScale = UIScreen.main.nativeScale
        return layer
    }
    
    private func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (angle * CGFloat.pi) / 180
    }
    
    private func percent(_ random: UInt32) -> CGFloat {
        return CGFloat(random) / 10.0
    }
    
    private var random: UInt32 {
        return max(1, arc4random_uniform(10))
    }
    
    func fire(_ zanCount: Int = 0) {
        var wrappers: [LayerWrapper] = []
        
        for i in 0 ..< 6 {
            let iconNo = arc4random_uniform(10)
            print("🌹 图片iconNo: \(iconNo)")
            if let layer = createEmitterLayer(with: "emoji_1f60\(iconNo)") {
                emitterLayer.addSublayer(layer)
                let xCosAngle = _xCosAngles[i % _xCosAngles.count]
                let yTanAngle = _yTanAngles[i % _yTanAngles.count]
                let wrapper = LayerWrapper(layer: layer, xCosAngle: xCosAngle, yTanAngle: yTanAngle)
                wrappers.append(wrapper)
            }
        }
        
        print("🌹 有效个数: \(wrappers.count)")
        
        _cachedBezierPaths.removeAll()
        
        let radius = width * 0.9
        for wrapper in wrappers {
            print("🐛 角度  cos \(wrapper.xCosAngle), tan \(wrapper.yTanAngle)")
            let layer = wrapper.layer
            
            let rangeInsideMaxX = radius * cos(degreesToRadians(wrapper.xCosAngle))
            let randomX = random
            let percentX = percent(randomX)
            let offsetX = rangeInsideMaxX * percentX
            var offsetY: CGFloat = 0.0
            
            if wrapper.xCosAngle == wrapper.yTanAngle {
                let offsetY1 = offsetX * tan(degreesToRadians(wrapper.yTanAngle))
                let randomY = random
                let percentY = percent(randomY)
                offsetY = offsetY1 + percentY * (radius - offsetY1)
            } else {
                let rangeInsideMaxY = offsetX * tan(degreesToRadians(wrapper.yTanAngle))
                let randomY = random
                let percentY = percent(randomY)
                offsetY = rangeInsideMaxY * percentY
            }
            
            let startPoint = layer.position
            let endPoint = CGPoint(x: startPoint.x + offsetX, y: startPoint.y - offsetY)
            
            // 动画配置
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.values = [startPoint, endPoint]
            positionAnimation.keyTimes = [0.0, 1.0]
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let controlPointX = startPoint.x + offsetX * 0.8
            let controlPointY = endPoint.y - offsetY * 0.2
            let controlPoint = CGPoint(x: controlPointX, y: controlPointY)
            let bezierPath = UIBezierPath()
            bezierPath.move(to: startPoint)
            bezierPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
            positionAnimation.path = bezierPath.cgPath

            _cachedBezierPaths.append(CachedPath(path: bezierPath, startPoint: startPoint, controlPoint: controlPoint, endPoint: endPoint))
            
            let alphaAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
            alphaAnimation.values = [0.9, 1.0, 0.0]
            alphaAnimation.keyTimes = [0.0, 0.6, 1.0]
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnimation, alphaAnimation]
            groupAnimation.duration = 0.68
            groupAnimation.isRemovedOnCompletion = true
            groupAnimation.delegate = self
            
            groupAnimation.setValue(layer, forKey: "layerName")
            layer.add(groupAnimation, forKey: "groupAnimation")
        }
        
        // 创建文本组件
        if zanCount > 0 && zanCount <= 1000 {
            _numberLayer.backgroundColor = UIColor.yellow.cgColor
            _numberLayer.height = 30.0
            let numberLayerWidth = _createNumberLayers(with: zanCount)
            _numberLayer.width = numberLayerWidth
            _numberLayer.position = emitterLayer.center
        } else {
            _numberLayer.removeAllSublayers()
        }
        
        setNeedsDisplay()
    }
    
    private var _numberLayer: CALayer = CALayer()
    
    fileprivate func _createNumberLayers(with zanCount: Int) -> CGFloat {
        _numberLayer.removeAllSublayers()
        
        var x: CGFloat = 0.0
        var count: Int = 0
        let xOffset: CGFloat = 3.0
        
        let text = String(zanCount)
        for character in text {
            if let image = UIImage(named: String(character)) {
                let layer = CALayer()
                layer.contents = image.cgImage
                layer.contentMode = .scaleAspectFit
                layer.size = CGSize(width: 12, height: 18)
                layer.left = x
                _numberLayer.addSublayer(layer)
                
                x += layer.width
                x += xOffset
                layer.centerY = _numberLayer.height / 2
                
                count += 1
            }
        }
        
        if zanCount <= 50 {
            if let image = UIImage(named: "太棒啦!") {
                let layer = CALayer()
                layer.contents = image.cgImage
                layer.contentMode = .scaleAspectFit
                layer.size = CGSize(width: 80, height: 24)
                layer.left = x
                _numberLayer.addSublayer(layer)
                
                x += layer.width
                x += xOffset
                layer.centerY = _numberLayer.height / 2
                
                count += 1
            }
        } else if zanCount <= 1000 {
            if let image = UIImage(named: "超满意~") {
                let layer = CALayer()
                layer.contents = image.cgImage
                layer.contentMode = .scaleAspectFit
                layer.size = CGSize(width: 80, height: 24)
                layer.left = x
                _numberLayer.addSublayer(layer)
                
                x += layer.width
                x += xOffset
                layer.centerY = _numberLayer.height / 2
                
                count += 1
            }
        }
        
        if count > 1 {
            x -= xOffset
        }
        
        return x
    }
    
    func stop() {
        _numberLayer.removeAllSublayers()
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
