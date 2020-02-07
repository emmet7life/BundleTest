//
//  DispatchQueue+Extension.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/7/11.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func safeSync(_ block: @escaping () -> ()) {
        if self == DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            sync { block() }
        }
    }
    
    func safeAsync(_ block: @escaping () -> ()) {
        if self == DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
