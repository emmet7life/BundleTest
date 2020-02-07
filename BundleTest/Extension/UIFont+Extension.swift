//
//  UIFont+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/6.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension UIFont {
    class func systemRegularFont(_ fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        } else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    class func systemLightFont(_ fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
        } else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    class func systemMediumFont(_ fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        } else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    class func systemSemiboldFont(_ fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
        } else {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
    
    class func systemBoldFont(_ fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
        } else {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
}

extension UIFont {
    //    "PingFang SC"
    //    - 0 : "PingFangSC-Medium"
    //    - 1 : "PingFangSC-Semibold"
    //    - 2 : "PingFangSC-Light"
    //    - 3 : "PingFangSC-Ultralight"
    //    - 4 : "PingFangSC-Regular"
    //    - 5 : "PingFangSC-Thin"
    
    class func pingFangSCRegularFont(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: fontSize) {
            return font
        }
        
        return systemRegularFont(fontSize)
    }
    
    class func pingFangSCLightFont(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Light", size: fontSize) {
            return font
        }
        
        return systemLightFont(fontSize)
    }
    
    class func pingFangSCMediumFont(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: fontSize) {
            return font
        }
        
        return systemMediumFont(fontSize)
    }
    
    class func pingFangSCSemiboldFont(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Semibold", size: fontSize) {
            return font
        }
        
        return systemSemiboldFont(fontSize)
    }
    
    class func pingFangSCBoldFont(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Bold", size: fontSize) {
            return font
        }
        
        return systemBoldFont(fontSize)
    }
}
