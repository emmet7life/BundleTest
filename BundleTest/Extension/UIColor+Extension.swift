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
    
    class var navBarTitleColor: UIColor {
        return mainColor
    }
    
    class var navBarBgColor: UIColor {
        return UIColor(white: 1, alpha: 0.94)
    }
    
    class var sepLineColor: UIColor {
        return UIColor.colorWithHexRGBA(0xe5e5e5)
    }
    
    class var sepRectColor: UIColor {
        return UIColor.colorWithHexRGBA(0xf4f4f4)
    }
    
    class var viewBgColor: UIColor {
        return UIColor.white
    }
    
    class var themeRed: UIColor {
        return UIColor.colorWithHexRGBA(0xff7379)
    }
    
    class var themeYellow: UIColor {
        return UIColor.colorWithHexRGBA(0xffcc33)
    }
    
    class var themeGreen: UIColor {
        return UIColor.colorWithHexRGBA(0x80f0b1)
    }
    
    class var mainColor: UIColor {
        return UIColor.colorWithHexRGBA(0x333333)
    }
    
    class var subColor: UIColor {
        return UIColor.colorWithHexRGBA(0x666666)
    }
    
    class var assitantColor: UIColor {
        return UIColor.colorWithHexRGBA(0x999999)
    }
    
    class var cellSelectedBgColor: UIColor {
        return UIColor.colorWithHexRGBA(0xd9d9d9)
    }
    
    class var selectedBgColor: UIColor {
        return UIColor.colorWithHexRGBA(0xFFCC33)
    }
    
    class var grayBgColor: UIColor {
        return UIColor.colorWithHexRGBA(0xD8D8D8)
    }
    
    class var cancelColor: UIColor {
        return UIColor.colorWithHexRGBA(0xFF9B79)
    }
    
    class var holderColor: UIColor {
        return UIColor.colorWithHexRGBA(0xCCCCCC)
    }
    
    /// 偏粉色：作者相关星次元人物背景 normal
    class var colorFF9DC6: UIColor {
        return UIColor.colorWithHexRGBA(0xff9dc6)
    }
    
    /// 偏橙色：作者相关星次元人物背景 top3
    class var colorFF9C59: UIColor {
        return UIColor.colorWithHexRGBA(0xff9c59)
    }
    
    /// 偏黄色：作者相关星次元人物背景 top1
    class var colorFDD655: UIColor {
        return UIColor.colorWithHexRGBA(0xfdd655)
    }
    
    class var colorF5F5F5: UIColor {
        return UIColor.colorWithHexRGBA(0xf5f5f5)
    }
    
    class var viewBackGroundColorF5: UIColor {
        return UIColor.colorF5F5F5
    }
    
    class var colorFF4C6A: UIColor {
        return UIColor.colorWithHexRGBA(0xff4c6a)
    }
    
    class var colorFF4D6A: UIColor {
        return UIColor.colorWithHexRGBA(0xff4d6a)
    }
    
    class var colorE6E6E6: UIColor {
        return UIColor.colorWithHexRGBA(0xe6e6e6)
    }
    
    class var color3D9CCC: UIColor {
        return UIColor.colorWithHexRGBA(0x3D9CCC)
    }
    
    class var color2A2A2A: UIColor {
        return UIColor.colorWithHexRGBA(0x2A2A2A)
    }
    
    class var colorF0F0F0: UIColor {
        return UIColor.colorWithHexRGBA(0xF0F0F0)
    }
    
    class var colorF6F6F6: UIColor {
        return UIColor.colorWithHexRGBA(0xF6F6F6)
    }
    
    class var colorFFF2F4: UIColor {
        return UIColor.colorWithHexRGBA(0xFFF2F4)
    }
    
    class var color33BBFF: UIColor {
        return UIColor.colorWithHexRGBA(0x33BBFF)
    }
    
    class var colorCCCCCC: UIColor {
        return UIColor.colorWithHexRGBA(0xCCCCCC)
    }
    
    class var color634FA4: UIColor {
        return UIColor.colorWithHexRGBA(0x634FA4)
    }
    // 字体颜色中像 orange 颜色的那种
    class var colorF26B00: UIColor {
        return UIColor.colorWithHexRGBA(0xF26B00)
    }
    
    class var colorEFEFEF: UIColor {
        return UIColor.colorWithHexRGBA(0xEFEFEF)
    }
    
    class var colorFFFBF0: UIColor {
        return UIColor.colorWithHexRGBA(0xFFFBF0)
    }
    
    class var color6A529F: UIColor {
        return UIColor.colorWithHexRGBA(0x6A529F)
    }
    
    class var colorF33D66: UIColor {
        return UIColor.colorWithHexRGBA(0xF33D66)
    }
    
    class var colorF86A83: UIColor {
        return UIColor.colorWithHexRGBA(0xF86A83)
    }
    
    class var colorFAFAFF: UIColor {
        return UIColor.colorWithHexRGBA(0xFAFAFF)
    }
    
    class var colorF7F7F7: UIColor {
        return UIColor.colorWithHexRGBA(0xF7F7F7)
    }
    
    class var colorFF6680: UIColor {
        return UIColor.colorWithHexRGBA(0xFF6680)
    }
    
    class var colorF2F2F2: UIColor { // 预加载页面骨骼色值
        return UIColor.colorWithHexRGBA(0xf2f2f2)
    }
    
    class var colorF75D79: UIColor { // 按钮角标等红色
        return UIColor.colorWithHexRGBA(0xf75d79)
    }
    
    class var colorFCBEC9: UIColor { // 按钮角标点下去淡红色
        return UIColor.colorWithHexRGBA(0xFCBEC9)
    }
    
    class var colorFCF7F8: UIColor { // 帖子置背景色
        return UIColor.colorWithHexRGBA(0xfcf7f8)
    }
    
    // 7.2.0
    class var color4A90E2: UIColor { // 话题高亮色
        return UIColor.colorWithHexRGBA(0x4A90E2)
    }
    
    // 7.6.0
    class var colorE0FFB3: UIColor { // 虚拟人物排行榜->下降
        return UIColor.colorWithHexRGBA(0xE0FFB3)
    }
    
    class var colorFFCCE1: UIColor { // 虚拟人物排行榜->上升
        return UIColor.colorWithHexRGBA(0xFFCCE1)
    }
    
    // 7.7.5
    class var color66D5FF: UIColor { // 喵饼兑换选中背景色
        return UIColor.colorWithHexRGBA(0x66D5FF)
    }
    
    class var colorFCB2B2: UIColor { // 喵饼兑换背景色
        return UIColor.colorWithHexRGBA(0xFCB2B2)
    }
    
    class var color4D92E3: UIColor { // 评论->展开/折叠
        return UIColor.colorWithHexRGBA(0x4D92E3)
    }
    
    class var randomRGB: UIColor {
        
        return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
    }
    
    // Hex String
    var hex: String {
        switch self {
        case UIColor.themeRed:
            return "#" + (UIColor.themeRed.hexString() ?? "ff7379")
        case UIColor.themeGreen:
            return "#" + (UIColor.themeGreen.hexString() ?? "80f0b1")
        case UIColor.themeYellow:
            return "#" + (UIColor.themeGreen.hexString() ?? "ffcc33")
        case UIColor.mainColor:
            return "#" + (UIColor.mainColor.hexString() ?? "333333")
        case UIColor.subColor:
            return "#" + (UIColor.subColor.hexString() ?? "666666")
        case UIColor.assitantColor:
            return "#" + (UIColor.assitantColor.hexString() ?? "999999")
        default:
            return "#" + (self.hexString() ?? "333333")
        }
    }
}
