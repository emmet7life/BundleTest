//
//  String+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/2.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension String {
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
}
