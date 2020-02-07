//
//  Global+Func.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/10.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

func delay(_ delta: TimeInterval, callFunc: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delta) {
        callFunc()
    }
}
