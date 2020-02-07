//
//  VCInterceptUIView.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/5.
//  Copyright © 2019 jianli chen. All rights reserved.
//

class VCInterceptUIView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
    
}
