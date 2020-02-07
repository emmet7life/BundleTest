//
//  SLUIColorExtension.swift
//
//  Created by 杨权 on 16/03/24.
//  Copyright © 2016 Year Star. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 生成带 alpha 通道的 RBG 颜色（0~255），alpha限定为1.0
    ///
    /// - Parameters:
    ///   - red: R (0~255)
    ///   - green: G (0~255)
    ///   - blue: B (0~255)
    /// - Returns: 对应颜色对象
    class func colorWithRGB(_ red: UInt, _ green: UInt, _ blue: UInt) -> UIColor {
        return self.colorWithRGBA(red, green, blue, 255)
    }
    
    /// 生成带 alpha 通道的 RBG 颜色（0~255）
    ///
    /// - Parameters:
    ///   - red: R (0~255)
    ///   - green: G (0~255)
    ///   - blue: B (0~255)
    ///   - alpha: alpha 通道（0~255）
    /// - Returns: 对应颜色对象
    class func colorWithRGBA(_ red: UInt, _ green: UInt, _ blue: UInt, _ alpha: UInt) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        } else {
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        }
    }
    
}
