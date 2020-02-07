//
//  WeiboLoadingViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/4.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class WeiboLoadingViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    fileprivate var _waiting: WeiboPicWaitingView = WeiboPicWaitingView(mode: .pieDiagram)
    fileprivate var _waiting2: WeiboPicWaitingView = WeiboPicWaitingView(frame: CGRect(x: 0, y: 0, width: 120, height: 120), mode: .loopDiagram)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_waiting)
        _waiting.center = view.center
        _waiting.frame.origin.y -= 120
        
        view.addSubview(_waiting2)
        _waiting2.center = view.center
        _waiting2.frame.origin.y += 180

        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.addTarget(self, action: #selector(onSliderValueChanged), for: .valueChanged)
    }

    @objc fileprivate func onSliderValueChanged() {
        _waiting.setProgress(CGFloat(slider.value))
        _waiting2.setProgress(CGFloat(slider.value))
//        _waiting.setFillColorAlpha(CGFloat(slider.value))
    }

}
