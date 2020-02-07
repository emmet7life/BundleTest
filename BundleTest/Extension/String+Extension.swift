//
//  String+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/2.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation
import YYText

extension String {
    
    static func address<T: AnyObject>(o: T) -> String {
        return String(format: "%014p", unsafeBitCast(o, to: Int.self))
    }
    
    func numberFormat(float: Int16 = 2, append: String = "+") -> String {
        if let num = Int64(self) {
            return numberFormat(num: num, float: float, append: append)
        }
        return "0"
    }
    
    func numberFormat(num: Int64, float: Int16 = 2, append: String = "+") -> String {
        let formatFloat = max(0, float)
        
        func calculate(val: Double, format: String) -> String {
            let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: float, raiseOnExactness: false,
                                                        raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let ouncesDecimal = NSDecimalNumber(value: val)
            let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
            return NSString(format: format as NSString, roundedOunces) as String
        }
        
        var wan = Double(num) / 100000000.0
        if wan >= 1.0 {
            return calculate(val: wan, format: "%@亿\(append)")
        } else {
            wan = Double(num) / 10000.0
            if wan >= 1.0 {
                return calculate(val: wan, format: "%@万\(append)")
            }
            return "\(num)"
        }
    }
    
    // YYTextLayout
    func createYYTextLayout(font: UIFont? = nil, fontSize: CGFloat = 14.0, textColor: UIColor = UIColor.colorWithHexRGBA(0x00D2FF),
                            lineBreakMode: NSLineBreakMode = .byTruncatingTail, alignment: NSTextAlignment = .left,
                            paddingTop: CGFloat = 5.0, paddingBottom: CGFloat = 5.0,
                            maximumNumberOfRows: UInt = 0,
                            width: CGFloat = CGFloat.greatestFiniteMagnitude,
                            height: CGFloat = CGFloat.greatestFiniteMagnitude) -> YYTextLayout? {
        let mutableText: NSMutableAttributedString = NSMutableAttributedString(string: self)
        mutableText.yy_color = textColor
        mutableText.yy_font = font ?? UIFont.systemRegularFont(fontSize)
        mutableText.yy_lineBreakMode = lineBreakMode
        mutableText.yy_alignment = alignment
        
        let modifier = VCYYTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: fontSize) ?? font
        modifier.paddingTop = paddingTop
        modifier.paddingBottom = paddingBottom
        
        let size: CGSize = CGSize(width: width, height: height)
        let contentContainer = YYTextContainer(size: size)
        contentContainer.maximumNumberOfRows = maximumNumberOfRows
        contentContainer.linePositionModifier = modifier
        
        if let layout = YYTextLayout(container: contentContainer, text: mutableText) {
            return layout
        }
        return nil
    }
}

// MARK: VCYYTextLinePositionModifier - 文本 Line 位置修改器
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@objc class VCYYTextLinePositionModifier: NSObject, YYTextLinePositionModifier {
    
    var font: UIFont!
    var paddingTop: CGFloat = 0.0
    var paddingBottom: CGFloat = 0.0
    var lineHeightMultiple: CGFloat = 0.0
    
    override init() {
        super.init()
        //if #available(iOS 9.0, *) {
        //    lineHeightMultiple = 1.34
        //} else {
        //    lineHeightMultiple = 1.3125
        //}
        
        // 7.4.0 增大行高
        if #available(iOS 9.0, *) {
            lineHeightMultiple = 1.54
        } else {
            lineHeightMultiple = 1.5125
        }
    }
    
    func height(with lineCount: UInt) -> CGFloat {
        let ascent: CGFloat = font.pointSize * 0.86
        let descent: CGFloat = font.pointSize * 0.14
        let lineHeight: CGFloat = font.pointSize * lineHeightMultiple
        return paddingTop + paddingBottom + ascent + descent + CGFloat(lineCount - 1) * lineHeight
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copyObj = VCYYTextLinePositionModifier()
        copyObj.font = font
        copyObj.paddingTop = paddingTop
        copyObj.paddingBottom = paddingBottom
        copyObj.lineHeightMultiple = lineHeightMultiple
        return copyObj
    }
    
    func modifyLines(_ lines: [YYTextLine], fromText text: NSAttributedString, in container: YYTextContainer) {
        let ascent: CGFloat = font.pointSize * 0.86
        let lineHeight: CGFloat = font.pointSize * lineHeightMultiple
        for line in lines {
            var position: CGPoint = line.position
            position.y = paddingTop + ascent + CGFloat(line.row)  * lineHeight
            line.position = position
        }
    }
    
}

extension String {
    func clipContent(with maxLength: Int = 15) -> String {
        let result = self as NSString
        if (result.length > maxLength) {
            let rangeIndex = result.rangeOfComposedCharacterSequence(at: maxLength)
            return result.substring(to: rangeIndex.location)
        }
        return self
    }
    
    func utf16Length() -> Int {
        return utf16.count
    }
    
    func isLengthOverflowInUTF16(with limit: Int = 2000) -> Bool {
        return utf16Length() > limit
    }
    
    func coverOauthNickName() -> String {
        let length = self.count//self.utf16Length()
        if length > 4 {
            let start = substring(to: index(startIndex, offsetBy: length - 4))
            return "\(start)****"
        } else if length >= 1 && length <= 4 {
            let start = substring(to: index(startIndex, offsetBy: length - 1))
            return "\(start)*"
        }
        return self
    }
}
