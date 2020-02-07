//
//  DispatchTime+Extension.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/6/26.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

extension DispatchTime {
    /**
     Create a dispatch time for a given seconds from now.
     */
    public init(secondsFromNow: TimeInterval) {
        let nanosecondsFromNow = secondsFromNow.nanoseconds
        var uptime = DispatchTime.now().uptimeNanoseconds
        if nanosecondsFromNow < 0 {
            uptime -= UInt64(-nanosecondsFromNow)
        } else {
            uptime += UInt64(nanosecondsFromNow)
        }
        self.init(uptimeNanoseconds: uptime)
    }
    
    /**
     Create a dispatch time for a given nanoseconds from now.
     */
    public init(nanosecondsFromNow: UInt64) {
        let uptime = DispatchTime.now().uptimeNanoseconds + nanosecondsFromNow
        self.init(uptimeNanoseconds: uptime)
    }
    
    /**
     Create a dispatch time for a given nanoseconds from now.
     */
    public init(microsecondsFromNow: UInt32) {
        let uptime = DispatchTime.now().uptimeNanoseconds + UInt64(microsecondsFromNow) * 1000
        self.init(uptimeNanoseconds: uptime)
    }
    
    public func nanosecondsFromNow() -> Int64 {
        return Int64(self.rawValue) - Int64(DispatchTime.now().rawValue)
    }
    
    public func microsecondsFromNow() -> Int64 {
        return nanosecondsFromNow() / 1000
    }
    
    public func added(seconds: TimeInterval) -> DispatchTime {
        let nanosecondsFromNow = seconds.nanoseconds
        var uptime = DispatchTime.now().uptimeNanoseconds
        if nanosecondsFromNow < 0 {
            uptime -= UInt64(-nanosecondsFromNow)
        } else {
            uptime += UInt64(nanosecondsFromNow)
        }
        return DispatchTime(uptimeNanoseconds: uptime)
    }
}
