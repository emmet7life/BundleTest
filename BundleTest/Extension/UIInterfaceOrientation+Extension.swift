//
//  UIInterfaceOrientation+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/11.
//  Copyright © 2019 jianli chen. All rights reserved.
//

extension UIInterfaceOrientation {
    var orientationMask: UIInterfaceOrientationMask {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return .all
        }
    }
}

extension UIInterfaceOrientationMask {
    
    var isLandscape: Bool {
        switch self {
        case .landscapeLeft, .landscapeRight, .landscape: return true
        default: return false
        }
    }
    
    var isPortrait: Bool {
        switch self {
        case . portrait, . portraitUpsideDown: return true
        default: return false
        }
    }
    
}
