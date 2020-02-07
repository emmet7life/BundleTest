//
//  CALayer+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/26.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension CALayer {
    class func createGradualColorLayer(color: [CGColor] =
        [
            UIColor.colorWithRGB(250, 107, 144).cgColor,
            UIColor.colorWithRGB(249, 106, 142).cgColor,
            UIColor.colorWithRGB(248, 90, 128).cgColor,
            UIColor.colorWithRGB(247, 83, 124).cgColor,
            UIColor.colorWithRGB(246, 75, 115).cgColor,
            UIColor.colorWithRGB(245, 70, 111).cgColor,
            UIColor.colorWithRGB(244, 63, 104).cgColor,
            UIColor.colorWithRGB(243, 57, 98).cgColor
        ],
                                       startPoint: CGPoint = CGPoint.zero,
                                       endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0),
                                       locations: [NSNumber] =
        [
            NSNumber(value: 0.15),
            NSNumber(value: 0.3),
            NSNumber(value: 0.45),
            NSNumber(value: 0.6),
            NSNumber(value: 0.75),
            NSNumber(value: 0.9),
            NSNumber(value: 0.95),
            NSNumber(value: 1.0)
        ],
                                       frame: CGRect = CGRect.zero ) -> CAGradientLayer {
        let gradualColorLayer: CAGradientLayer = CAGradientLayer()
        gradualColorLayer.colors = color
        gradualColorLayer.locations = locations
        gradualColorLayer.startPoint = startPoint
        gradualColorLayer.endPoint = endPoint
        gradualColorLayer.frame = frame
        return gradualColorLayer
    }
}
