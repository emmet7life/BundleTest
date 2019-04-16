//
//  UIColor+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 16进制颜色所含位数
    ///
    /// - HexBit3: 三位，不含 alpha 通道
    /// - HexBit4: 四位，含 alpha 通道
    /// - HexBit6: 六位，不含 alpha 通道
    /// - HexBit8: 八位，含 alpha 通道
    enum RGBAHexBitType {
        case hexBit3, hexBit4, hexBit6, hexBit8
    }
    
    /// 16进制数值表示的颜色（可带 alpha 通道值）
    ///
    /// - Parameters:
    ///   - hexValue: 16进制无符号整数，(0x0 到 0xFFFFFFFF)
    ///   - bitType: 用来表示所含颜色的位数，参考: “ RGBAHexBitType ”
    /// - Returns: 对应颜色对象
    class func colorWithHexRGBA(_ hexValue: UInt64, bitType: RGBAHexBitType = .hexBit6) -> UIColor {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        switch (bitType) {
        case .hexBit3:
            red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
            blue  = CGFloat(hexValue & 0x00F)              / 15.0
        case .hexBit4:
            red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
            blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
            alpha = CGFloat(hexValue & 0x000F)             / 15.0
        case .hexBit6:
            red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
            blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
        case .hexBit8:
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        }
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    class var colorF86A83: UIColor {
        return UIColor.colorWithHexRGBA(0xF86A83)
    }
}
