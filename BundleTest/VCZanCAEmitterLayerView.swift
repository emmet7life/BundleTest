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

extension CGRect {
    var vc_top: CGFloat {
        return origin.y
    }
    
    var vc_bottom: CGFloat {
        return origin.y + size.height
    }
    
    var vc_left: CGFloat {
        return origin.x
    }
    
    var vc_right: CGFloat {
        return origin.x + size.width
    }
    
    var vc_centerX: CGFloat {
        return origin.x + size.width * 0.5
    }
    
    var vc_centerY: CGFloat {
        return origin.y + size.height * 0.5
    }
    
    var vc_center: CGPoint {
        return CGPoint(x: vc_centerX, y: vc_centerY)
    }
}

class VCZanCAEmitterLayerView: VCLoadFromNibBaseView {

    // MARK: - View
    @IBOutlet var contentView: UIView!
    
    private var emitterLayer: CALayer {
        return contentView.layer
    }
    
    private var _numberLayer: CALayer = CALayer()
    
    // MARK: - Data
    
    // Path调试辅助结构体
    struct CachedPath {
        var path: UIBezierPath
        var startPoint: CGPoint
        var controlPoint: CGPoint
        var endPoint: CGPoint
    }
    
    // Layer包装结构体
    struct LayerWrapper {
        var layer: CALayer
        var xCosAngle: CGFloat
        var yTanAngle: CGFloat
    }
    
    // 位置枚举
    enum NumberPositionType {
        // 关联值代表x、y轴方向的偏移量
        case centerTop(CGFloat, CGFloat)
        case leftTop(CGFloat, CGFloat)
    }
    
    // 配置参数结构体
    struct Option {
        var isDebug: Bool = false                                                                                           // 是否调试模式
        var zanContainerFrame: CGRect = CGRect.zero                                                         // 点赞小图标所在的外围父组件的坐标(转化为全局Window窗口坐标)
        var zanIconFrame: CGRect = CGRect.zero                                                                  // 点赞小图标组件的坐标(转化为全局Window窗口坐标)
        var type: NumberPositionType = VCZanCAEmitterLayerView.defaultLeftTopType   // 数字Layer的坐标枚举，关联值代表x、y的偏移量
        var numberDismissDelayTime: TimeInterval = 0.15                                                  // 数字Layer消失的延迟时间
        var zanCountLevel0: Int = 1                                                                                       // 最小数为多少时，才展示数字Layer
        var zanCountLevel1: Int = 50                                                                                     // 此数范围内，数字Layer右侧展示”太棒啦“修饰图
        var zanCountLevel2: Int = 1000                                                                                 // 此数范围内，数字Layer右侧展示”超满意“修饰图
        var iconSize: CGSize = CGSize(width: 24.0, height: 24.0)                                           // 粒子大小
        var iconEmitterLifeTime: CFTimeInterval = 0.68                                                        // 粒子存活时间
        var oneShotIconEmitterCount: Int = 6                                                                       // 一次喷射几个粒子
        var canUsageIconEmitterCount: UInt32 = 10                                                             // 可用粒子图总数
        var iconNamePrefix: String = "emoji_1f60"                                                                // 粒子图名称前缀
        var iconNameGenerator: ((Int) -> String)? = nil                                                         // 粒子图名称生成器
        var radiusMultiplePercent: CGFloat = 0.9                                                                   // 以赞ICON为中心的粒子喷射半径
        var minRadiusPercentRandom: UInt32 = 2                                                                // 最少可随机出的半径范围的百分比
        var numberIconSize: CGSize = CGSize(width: 12, height: 18)                                    // 数字Layer的单个ICON大小
        var numberDecorateTextSize: CGSize = CGSize(width: 80, height: 24)                      // 修饰图Layer的大小
        var bezierControlPointXOffsetPercent: CGFloat = 0.8                                                // 控制粒子贝塞尔曲线的控制点偏移量
        var bezierControlPointYOffsetPercent: CGFloat = 0.2                                                // 控制粒子贝塞尔曲线的控制点偏移量
    }
    
    // cos tan
    private var _xCosAngles: [CGFloat] = [0, 30, 60, 120, 150, 180]
    private var _yTanAngles: [CGFloat] = [30, 60, 60, 120, 150, 180]
    
    private var _cachedBezierPaths: [CachedPath] = []
    
    static let defaultCenterTopType: NumberPositionType = NumberPositionType.centerTop(0, -16)
    static let defaultLeftTopType: NumberPositionType = NumberPositionType.leftTop(-16, -16)
    
    private(set) var option: Option = Option()
    
    func updatePosition(with option: Option) {
        self.option = option
    }
    
    func updateZanIconFrame(with frame: CGRect) {
        option.zanIconFrame = frame
    }
    
    func updateZanContainerFrame(with frame: CGRect) {
        option.zanContainerFrame = frame
    }
    
    init(option: Option) {
        super.init()
        self.option = option
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initialize() {
        isUserInteractionEnabled = false
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        emitterLayer.addSublayer(_numberLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard option.isDebug else { return }
        
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
    
    // 创建粒子
    private func createEmitterLayer(with icon: String) -> CALayer? {
        guard let image = UIImage(named: icon) else { return nil }
        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: option.iconSize)
        layer.position = option.zanIconFrame.vc_center
        layer.contents = image.cgImage
        layer.contentsScale = UIScreen.main.nativeScale
        return layer
    }
    
    // 角度转弧度
    private func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (angle * CGFloat.pi) / 180
    }
    
    // 百分比
    private func percent(_ random: UInt32) -> CGFloat {
        return CGFloat(random) / 10.0
    }
    
    // 随机数
    private var random: UInt32 {
        return max(option.minRadiusPercentRandom, arc4random_uniform(10))
    }
    
    // 发射粒子
    // - zanCount: 粒子个数
    func fire(_ zanCount: Int) {
        
        var wrappers: [LayerWrapper] = []
        
        for i in 0 ..< option.oneShotIconEmitterCount {
            
            var iconName = ""
            if let iconNameGenerator = option.iconNameGenerator {
                iconName = iconNameGenerator(i)
            } else {
                let iconNo = arc4random_uniform(option.canUsageIconEmitterCount)
                iconName = "\(option.iconNamePrefix)\(iconNo)"
                print("🌹 图片iconNo: \(iconNo)")
            }
            
            if let layer = createEmitterLayer(with: iconName) {
                emitterLayer.addSublayer(layer)
                let xCosAngle = _xCosAngles[i % _xCosAngles.count]
                let yTanAngle = _yTanAngles[i % _yTanAngles.count]
                let wrapper = LayerWrapper(layer: layer, xCosAngle: xCosAngle, yTanAngle: yTanAngle)
                wrappers.append(wrapper)
            }
        }
        
        print("🌹 有效个数: \(wrappers.count)")
        
        _cachedBezierPaths.removeAll()
        
        let radius = width * option.radiusMultiplePercent
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
            
            let controlPointX = startPoint.x + offsetX * option.bezierControlPointXOffsetPercent
            let controlPointY = endPoint.y - offsetY * option.bezierControlPointYOffsetPercent
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
            groupAnimation.duration = option.iconEmitterLifeTime
            groupAnimation.isRemovedOnCompletion = true
            groupAnimation.delegate = self
            
            groupAnimation.setValue(layer, forKey: "layerName")
            layer.add(groupAnimation, forKey: "groupAnimation")
        }
        
        // 创建文本组件
        if zanCount > option.zanCountLevel0 && zanCount <= option.zanCountLevel2 {
            if option.isDebug {
                _numberLayer.backgroundColor = UIColor.yellow.cgColor
            }
            _numberLayer.height = 30.0
            let numberLayerWidth = _createNumberLayers(with: zanCount)
            _numberLayer.width = numberLayerWidth
            
            switch option.type {
            case .centerTop(let offsetX, let offsetY):
                _numberLayer.centerX = option.zanContainerFrame.vc_centerX + offsetX
                _numberLayer.top = option.zanContainerFrame.vc_top - _numberLayer.height + offsetY
            case .leftTop(let offsetX, let offsetY):
                _numberLayer.left = option.zanContainerFrame.vc_left - _numberLayer.width + offsetX
                _numberLayer.top = option.zanContainerFrame.vc_top - _numberLayer.height + offsetY
            }
            _numberLayer.zPosition = 1
        } else {
            _numberLayer.removeAllSublayers()
        }
        
        setNeedsDisplay()
    }
    
    // 创建数字Layer
    // - zanCount: 赞数
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
                layer.size = option.numberIconSize
                layer.left = x
                _numberLayer.addSublayer(layer)
                
                x += layer.width
                x += xOffset
                layer.centerY = _numberLayer.height / 2
                
                count += 1
            }
        }
        
        if zanCount <= option.zanCountLevel1 {
            if let image = UIImage(named: "太棒啦!") {
                let layer = CALayer()
                layer.contents = image.cgImage
                layer.contentMode = .scaleAspectFit
                layer.size = option.numberDecorateTextSize
                layer.left = x
                _numberLayer.addSublayer(layer)
                
                x += layer.width
                x += xOffset
                layer.centerY = _numberLayer.height / 2
                
                count += 1
            }
        } else if zanCount <= option.zanCountLevel2 {
            if let image = UIImage(named: "超满意~") {
                let layer = CALayer()
                layer.contents = image.cgImage
                layer.contentMode = .scaleAspectFit
                layer.size = option.numberDecorateTextSize
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
    
    // 停止（移除数字Layer）
    func stop() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + option.numberDismissDelayTime) { [weak self] in
            self?._numberLayer.removeAllSublayers()
        }
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
