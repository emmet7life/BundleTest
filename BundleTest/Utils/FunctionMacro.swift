//
//  FunctionMacro.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/5.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

func __isSimulator() -> Bool {
    #if targetEnvironment(simulator)
    //模拟器
    return true
    #else
    // 真机
    return false
    #endif
}

func __devlog(_ items: Any...) {
    if __isSimulator() {
        //模拟器
        print(items)
    } else {
        // 真机
    }
}
