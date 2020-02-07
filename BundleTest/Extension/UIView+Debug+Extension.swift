//
//  UIView+Debug+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2020/1/15.
//  Copyright © 2020 jianli chen. All rights reserved.
//

import Foundation

// 调试时的工具类方法
extension UIView {
    
    // MARK: - 为视图边界绘制出可见的颜色
    func boundDebug(_ borderColor: UIColor = UIColor.red, borderWidth: CGFloat = 1.0) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
}
