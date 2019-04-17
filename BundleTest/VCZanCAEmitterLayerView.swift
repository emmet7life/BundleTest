//
//  VCZanCAEmitterLayerView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/17.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCCAEmitterLayerWrapper {
    
    let layer: CAEmitterLayer
    var beginTime: CFTimeInterval
    
    init(layer: CAEmitterLayer, beginTime: CFTimeInterval = 0) {
        self.layer = layer
        self.beginTime = beginTime
    }
    
    func begin(with duration: TimeInterval = 1.0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) { [weak self] in
            self?.end()
        }
        
        if layer.emitterCells == nil {
            var cells: [CAEmitterCell] = []
            for _ in 0 ..< 6 {
                let iconNo = arc4random_uniform(10)
                if let cell = getCAEmitterCell(with: "emoji_1f60\(iconNo)") {
                    cells.append(cell)
                }
            }
            layer.emitterCells = cells
        }
        
        birthRate(with: 1.0)
        beginTime = CACurrentMediaTime()
        layer.beginTime = beginTime - 1
    }
    
    func end() {
//        DispatchQueue.main.async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.beginTime = 0.0
//            strongSelf.birthRate(with: 0.0)
//            strongSelf.layer.emitterCells = nil
//        }
        beginTime = 0.0
        birthRate(with: 0.0)
//        layer.emitterCells = nil
    }
    
    private func birthRate(with rate: Float) {
        if let cells = layer.emitterCells {
            for cell in cells {
                cell.birthRate = rate
            }
            layer.birthRate = rate
        }
    }
    
    var timePassed: CFTimeInterval {
        return CACurrentMediaTime() - beginTime
    }
    
    var isEnded: Bool {
        return timePassed > 1.0
    }
    
    private func getCAEmitterCell(with iconName: String) -> CAEmitterCell? {
        guard let iconImage = UIImage(named: iconName) else {
            return nil
        }
        let cell = CAEmitterCell()
        cell.contents = iconImage.cgImage
        cell.name = iconName
        cell.birthRate = 0.0//  每秒产生几个粒子
        cell.lifetime = 1.5// 粒子存活的时间,以秒为单位
        cell.lifetimeRange = 0.0
        cell.scale = 1.0
        
        cell.contentsScale = UIScreen.main.scale
        
        cell.alphaRange = 1.0
        cell.alphaSpeed = -1.0
        
        cell.yAcceleration = 450
        
        cell.velocity = 450
        cell.velocityRange = 30
        
        cell.emissionLongitude = 3 * CGFloat.pi / 2
        cell.emissionRange = CGFloat.pi / 2
        
        cell.spin = CGFloat.pi * 2
        cell.spinRange = CGFloat.pi * 2
        
        return cell
    }
}

class VCZanCAEmitterLayerView: VCLoadFromNibBaseView {

    // MARK: - View
    @IBOutlet var contentView: UIView!
    
    private var _dequeLayerMask: UInt64 = 0
    private var _emitterLayerQueue: [VCCAEmitterLayerWrapper] = []
    
    private func createEmitterLayer() -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.name = String("CAEmitterLayer_\(_dequeLayerMask)")
        layer.emitterSize = CGSize(width: 30, height: 30)
        layer.masksToBounds = false
        layer.renderMode = kCAEmitterLayerAdditive
        _dequeLayerMask += 1
        return layer
    }
    
    private func dequeEmitterLayer() -> VCCAEmitterLayerWrapper {
        if _emitterLayerQueue.isEmpty {
            let layer = VCCAEmitterLayerWrapper(layer: createEmitterLayer())
            _emitterLayerQueue.append(layer)
            return layer
        } else {
            for layer in _emitterLayerQueue {
                if layer.isEnded {
                    return layer
                }
            }
            if _emitterLayerQueue.count >= 3 {
                if let timePassedMaxLayer = (_emitterLayerQueue.max { return $0.timePassed < $1.timePassed }) {
                    return timePassedMaxLayer
                }
            }
            let layer = VCCAEmitterLayerWrapper(layer: createEmitterLayer())
            _emitterLayerQueue.append(layer)
            return layer
        }
    }
    
    private func getBirthRateNotZeroLayer() -> CAEmitterLayer? {
        for layer in _emitterLayerQueue {
            if layer.layer.birthRate > 0 {
                return layer.layer
            }
        }
        return nil
    }
    
    override func initialize() {
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for layer in _emitterLayerQueue {
            layer.layer.position = contentView.center
        }
    }
    
    func fire() {
        let layerWrapper = dequeEmitterLayer()
        if layerWrapper.layer.superlayer == nil {
            contentView.layer.addSublayer(layerWrapper.layer)
            setNeedsLayout()
        }
        layerWrapper.begin()
        setNeedsDisplay()
    }
    
    func stop() {
//        let layer = getBirthRateNotZeroLayer()
//        birthRate(with: layer, rate: 0)
    }
    
//    private func birthRate(with emitterLayer: CAEmitterLayer?, rate: Float) {
//        if let layer = emitterLayer, let cells = layer.emitterCells {
//            for cell in cells {
//                cell.birthRate = rate
//            }
//            layer.birthRate = rate
//        }
//    }
}
