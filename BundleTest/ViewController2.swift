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

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let view1 = UIView()
//        view1.backgroundColor = .yellow
//        view1.frame = CGRect(x: 0, y: 150, width: 200, height: 200)
//        view.addSubview(view1)
//
//        let view2 = UIView()
//        view2.backgroundColor = .green
//        view2.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
//        view1.addSubview(view2)
//
//        let simpleAnimateLabel = VCSimpleAnimateLabel()
//        simpleAnimateLabel.frame = CGRect(x: 0, y: 100, width: 100, height: 40)
//        simpleAnimateLabel.backgroundColor = .red
//        simpleAnimateLabel.option.upLabelColor = .white
//        simpleAnimateLabel.option.downLabelColor = .white
//        view.addSubview(simpleAnimateLabel)
//
////        simpleAnimateLabel.right = view.width
//
//        var num: Int = 9
//        var isUp = false
//        simpleAnimateLabel.setText(with: "\(num)", isUp: isUp, animated: false)
//        simpleAnimateLabel.userTappedActionBlock = {
//            num += 1
//            isUp = !isUp
////            simpleAnimateLabel.setText(with: "\(num)", isUp: isUp, animated: true)
////            simpleAnimateLabel.width = 200
//
//            if isUp {
//                view1.size = CGSize(width: 100, height: 100)
//            } else {
//                view1.size = CGSize(width: 200, height: 200)
//            }
//        }
        
        view.backgroundColor = UIColor.lightGray

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"
        
        let zanCALayerView = VCZanCAEmitterLayerView()
        zanCALayerView.frame = view.bounds
        view.addSubview(zanCALayerView)
        
//        var isUp = false
        let data = VCItemData()
        let likeBtn = VCSuperLikeButton()
        likeBtn.frame = CGRect(x: 0, y: 150, width: 80, height: 30)
        likeBtn.right = view.width
        var options = likeBtn.options
        options.layoutDirection = .trailing
        
        view.addSubview(likeBtn)
        likeBtn.setItemData(with: data)
        likeBtn.userTappedActionBlock = { type in
//            var options = likeBtn.options
//            isUp = !isUp
//            data.isZaned = !data.isZaned
//            if isUp {
//                options.layoutDirection = .leading
//                data.increaseZanNum()
//            } else {
//                data.decreaseZanNum()
//            }
            
//            likeBtn.options = options
//            let newWidth = likeBtn.setItemData(with: data, animated: true)
//            likeBtn.width = newWidth
            
            print("userTappedActionBlock~~~~"+type.flagString)
            
            switch type {
            case .quickTapping(_, _):
                zanCALayerView.fire()
            case .quickTappedFired:
                zanCALayerView.stop()
            case .longPressFiredStart(_):
                break
            case .longPressFiring(_):
                zanCALayerView.fire()
            case .longPressFingerTouchUp:
                break
            case .longPressFireEnded(_):
                break
            }
        }
        
//        test()
        
//        let arr: [Int] = [1,2,3]
//        let max = arr.max {  $0 < $1 }
//        print(max)
        
//        for _ in 0..<20 {
//            print(CGFloat(arc4random_uniform(10)) / 10.0)
//        }
        
//        for _ in 0...10 {
            let radius = view.width * 0.5
            let angle1: CGFloat = 30.0
            let angle2: CGFloat = 60.0
            let rangeInsideMaxX = radius * cos(degreesToRadians(angle1))
            let randomX = random
            let percentX = percent(randomX)
            let offsetX = rangeInsideMaxX * percentX
        
            let offsetY = offsetX * tan(degreesToRadians(angle2))
            let randomY = random
            let percentY = percent(randomY)
            let rangeInsideMaxY = offsetY + percentY * (radius - offsetY)
//            let targetY = rangeInsideMaxY * percentY
            print("(\(offsetX), \(rangeInsideMaxY))")
//        }
    }
    
    private func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (angle * CGFloat.pi) / 180
    }
    
    private var random: UInt32 {
        return max(2, arc4random_uniform(10))
    }
    
    private func percent(_ random: UInt32) -> CGFloat {
        return CGFloat(random) / 10.0
    }
    
    private var _test: Bool = true
    
    func test() {
        
        print("Test0")
        
        defer {
            print("Test3")
        }
        
        guard !_test else {
            print("Test 1")
            return
        }
        
        print("Test2")
        
//        print("Test4")
    }

}
