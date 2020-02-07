//
//  ViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/4/16.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class ELActivityBackgroudButtonViewController: UIViewController {
    
    @IBOutlet weak var backgroundButton: ELActivityBackgroudnButton!
    @IBOutlet weak var backgroundButton2: ELActivityBackgroudnButton!
    
    @IBOutlet weak var arrowBtn: UIButton!
    
    
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        if let imageView = arrowBtn.imageView {
            UIView.animate(withDuration: 0.36) {
                if imageView.transform == CGAffineTransform.identity {
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                } else {
                    imageView.transform = CGAffineTransform.identity
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        maskLayerView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundButton.title = "签到有礼"
        backgroundButton2.title = "明天再来哦"
        
//        var frame = CGRect.zero
//
////        let capInsets = UIEdgeInsets(top: 24, left: 30, bottom: 25, right: 43)
//        let capInsets = UIEdgeInsets(top: 24, left: 30, bottom: 25, right: 43)
//        let image2 = UIImage(named: "mask_layer2")?.withRenderingMode(.alwaysOriginal).resizableImage(withCapInsets: capInsets, resizingMode: .tile)
//
//        let imageView = UIImageView()
//        imageView.image = image2
//        imageView.sizeToFit()
//
//        frame = imageView.frame
//        frame.size.width += 200
//
//        imageView.layer.frame = frame
//
//        let imageView2 = UIImageView()
//        let image = UIImage(named: "mask_layer")?.withRenderingMode(.alwaysOriginal).resizableImage(withCapInsets: capInsets, resizingMode: .tile)
//        imageView2.image = image
//        imageView2.sizeToFit()
//
//        frame = imageView2.frame
//        frame.size.width += 200
//
//        imageView2.layer.frame = frame
//
//        let layer = imageView2.layer
//        imageView2.layer.removeFromSuperlayer()
//
//        //        let maskLayer = CALayer()
//        //        maskLayer.frame = frame
//
//        maskBgView.layer.addSublayer(layer)
//
//        maskBgView.layer.mask = imageView.layer
        
//        view.addSubview(imageView)
        
//        maskBgView.image = image
        
//        let arcCenter = CGPoint.init(x: 10, y: 10)
//        let bezier = UIBezierPath(arcCenter: arcCenter, radius: 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
////        UIColor.red.setFill()
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = UIColor.red.cgColor
//        shapeLayer.path = bezier.cgPath
//        shapeLayer.frame = CGRect(x: 10, y: 400, width: 20, height: 20)
        
//        let childView = UIView()
//        childView.frame = CGRect(x: 10, y: 400, width: 20, height: 20)
//        childView.layer.addSublayer(shapeLayer)
//        view.addSubview(childView)
        
//        view.layer.addSublayer(shapeLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

