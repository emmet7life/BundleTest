//
//  ViewController2.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCItemData: VCZanItemDataProtocol {
    var isZaned: Bool = false
    
    var zanNum: Int = 3
    var interfacedZanNum: Int = 0
    
    var visibleText: String {
        if zanNum <= 0 {
            return ""
        } else {
            return "\(zanNum)"
        }
    }
    
    var isZanNumUpdated: Bool = false
    
    func resetZanOperatorRelaProperties() {
        isZanNumUpdated = false
    }
    
}

class ViewController2: UIViewController {

    var isDebug = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray

//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"
        
        let position = VCZanCAEmitterLayerView.OutViewPositionInfo()
        let zanCALayerView = VCZanCAEmitterLayerView(position: position)
        zanCALayerView.frame = view.bounds
        view.addSubview(zanCALayerView)
        
        let view2 = UIView()
        view2.backgroundColor = .darkGray
        view2.frame = CGRect(x: 150, y: 300, width: 100, height: 50)
        view.addSubview(view2)
        
        let rectView = UIView()
        rectView.isUserInteractionEnabled = false
        if isDebug {
            rectView.alpha = 0.36
            rectView.backgroundColor = .yellow
        }
        view.addSubview(rectView)
        
        let rectView2 = UIView()
        rectView2.isUserInteractionEnabled = false
        if isDebug {
            rectView2.alpha = 0.36
            rectView2.backgroundColor = .green
        }
        view.addSubview(rectView2)
        
        let likeBtn = VCSuperLikeButton(frame: CGRect(x: 10, y: 10, width: 80, height: 30))
        
        var options = likeBtn.options
        options.isDebug = isDebug
        options.isFixedWidth = false
        options.layoutDirection = .trailing
        likeBtn.options = options
        
        view2.addSubview(likeBtn)
        
        let data = VCItemData()
        let newWidth = likeBtn.setItemData(with: data)
        likeBtn.width = newWidth
        
        likeBtn.userTappedActionBlock = { type in
            
            let frame1 = likeBtn.convertRectToWindow()
            let frame2 = likeBtn.praiseImageView.convertRectToWindow()
            
            rectView.frame = frame1
            rectView2.frame = frame2
            
            zanCALayerView.updateZanContainerFrame(with: frame1)
            zanCALayerView.updateZanIconFrame(with: frame2)
            
            print("userTappedActionBlock~~~~"+type.flagString)
            
            switch type {
            case .quickTapping(_, let count, let isZaned):
                if isZaned {
                    zanCALayerView.fire(count)
                }
            case .quickTappedFired:
                zanCALayerView.stop()
            case .longPressFiredStart(let count):
                zanCALayerView.fire(count)
            case .longPressFiring(let count):
                zanCALayerView.fire(count)
            case .longPressFingerTouchUp:
                break
            case .longPressFireEnded(_):
                zanCALayerView.stop()
            }
        }
        
        view.bringSubview(toFront: zanCALayerView)
        
//        for _ in 0..<20 {
//            print(CGFloat(arc4random_uniform(10)) / 10.0)
//        }
        
//        for _ in 0...10 {
//            let radius = view.width * 0.5
//            let angle1: CGFloat = 30.0
//            let angle2: CGFloat = 60.0
//            let rangeInsideMaxX = radius * cos(degreesToRadians(angle1))
//            let randomX = random
//            let percentX = percent(randomX)
//            let offsetX = rangeInsideMaxX * percentX
//
//            let offsetY = offsetX * tan(degreesToRadians(angle2))
//            let randomY = random
//            let percentY = percent(randomY)
//            let rangeInsideMaxY = offsetY + percentY * (radius - offsetY)
//            print("(\(offsetX), \(rangeInsideMaxY))")
//        }
    }
    
//    private func degreesToRadians(_ angle: CGFloat) -> CGFloat {
//        return (angle * CGFloat.pi) / 180
//    }
//
//    private var random: UInt32 {
//        return max(2, arc4random_uniform(10))
//    }
//
//    private func percent(_ random: UInt32) -> CGFloat {
//        return CGFloat(random) / 10.0
//    }

}
