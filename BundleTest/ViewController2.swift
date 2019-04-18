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
    var zanNum: Int = 0
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

    var isDebug = true
    // 最后的请求是不是赞，请求结束，置为nil
    var isLastRequestIsZanAction: Bool? = nil
    
    // 模拟网络请求
    // delay: 延迟多久执行
    // duration: 执行时间
    fileprivate func simulateZanReq(delay: TimeInterval = 0.0, duration: TimeInterval = 6.0, isZanReq: Bool) {
        isLastRequestIsZanAction = isZanReq
        SwiftTimer.debounce(interval: .fromSeconds(6.0), identifier: className()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLastRequestIsZanAction = nil
            print("🌍🌍🌍🌍请求完成✅(\(isZanReq))🌍🌍🌍🌍")
        }
    }
    
    fileprivate func cancelReq(_ isZanReq: Bool) {
        print("🌍🌍🌍🌍请求取消❌(\(isZanReq))🌍🌍🌍🌍")
        SwiftTimer.cancelThrottlingTimer(identifier: className())
    }
    
    fileprivate func cancelReqIfNeeded(isZan: Bool) {
        // 上一次和这一次请求类型不一致，则取消上一次请求
        if let isLastZanReq = isLastRequestIsZanAction, isZan != isLastZanReq {
            print("❌取消上一次的\(isLastZanReq)，本次操作为\(isZan)❌")
            cancelReq(isLastZanReq)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray

//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"
        
        var option = VCZanCAEmitterLayerView.Option()
        option.isDebug = isDebug
        
        let zanCALayerView = VCZanCAEmitterLayerView(option: option)
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
        
        likeBtn.userTappedActionBlock = { [weak self] type in
            
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
                    // 赞
                    zanCALayerView.fire(count)
                    self?.cancelReqIfNeeded(isZan: true)
                } else {
                    // 取消赞
                    self?.cancelReqIfNeeded(isZan: false)
                }
            case .quickTappedFired(let isZaned, let isNeedRequest):
                // (快速连续点击)动作真正的结束啦
                zanCALayerView.stop()
                if isNeedRequest {
                    // 需要网络请求
                    if isZaned {
                        // 赞
                        print("🌐🌐🌐~\\(≧▽≦)/~ 赞请求")
                        self?.simulateZanReq(isZanReq: true)
                    } else {
                        // 取消赞
                        print("🌐🌐🌐~\\(≧▽≦)/~ 取消赞请求")
                        self?.simulateZanReq(isZanReq: false)
                    }
                }
            case .longPressFiredStart(let count):
                // 赞
                zanCALayerView.fire(count)
                self?.cancelReqIfNeeded(isZan: true)
            case .longPressFiring(let count):
                // 赞
                zanCALayerView.fire(count)
                self?.cancelReqIfNeeded(isZan: true)
            case .longPressFingerTouchUp:
                // 可忽略此状态
                break
            case .longPressFireEnded(_, let isZaned, let isNeedRequest):
                // (长按)动作真正的结束啦
                zanCALayerView.stop()
                if isNeedRequest {
                    // 需要网络请求
                    if isZaned {
                        // 赞
                        print("🌐🌐🌐~\\(≧▽≦)/~ 赞请求")
                        self?.simulateZanReq(isZanReq: true)
                    } else {
                        // 取消赞
                        print("🌐🌐🌐~\\(≧▽≦)/~ 取消赞请求")
                        self?.simulateZanReq(isZanReq: false)
                    }
                }
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
