//
//  UIViewController+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/22.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

// iOS 11.0 extension
extension UIViewController {
    
    var viewSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    // 仅适用于导航栏和状态栏处于可见状态使用
    var viewSafeAreaInsetsAddtionTop: CGFloat {
        return max(0, viewSafeAreaInsets.top - 64.0)// 44.0 + 20.0 导航栏加状态栏
    }

}
