//
//  UIEdgeInsets+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/9/19.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension UIEdgeInsets {
    var vertical: CGFloat {
        return top + bottom
    }
    
    var horizontal: CGFloat {
        return left + right
    }
}
