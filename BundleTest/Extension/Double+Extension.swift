//
//  Double+Extension.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/6/26.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

extension Double {
    var nanoseconds: Double {
        return self * Double(1_000_000_000)
    }
}
