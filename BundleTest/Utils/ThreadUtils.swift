//
//  ThreadUtils.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/6/26.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

private let _syncSemaphore = DispatchSemaphore(value: 1)

/// 模拟OC的同步关键字：synchronized 的方法
///
/// - Parameters:
///   - obj: 同步锁
///   - closure: 线程安全的可执行闭包
func synchronized(_ obj: Any, closure: () -> Void) {
    objc_sync_enter(obj)
    closure()
    objc_sync_exit(obj)
}

/// 安全的在多线程中执行闭包
///
/// - Parameters:
///   - timeout: 等待的超时时间
///   - closure: 执行闭包
func exeInMultipleThreadSafety(_ timeout: DispatchTime = .distantFuture, closure: () -> Void) {
    let result = _syncSemaphore.wait(timeout: timeout)
    switch result {
    case .success:
        closure()
        _syncSemaphore.signal()
    case .timedOut:
        // 等待超时时信号量会自动+1，因此不能执行signal操作
        break
    }
}
