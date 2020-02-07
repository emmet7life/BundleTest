//
//  VCTimerThread.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/5.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

// MARK: - 计时器线程
// ⚠️ 注意，务必在使用本类的归属类的deinit方法中，调用stopTimer方法
// (无论是否调用过startTimer)，否则会造成runloop无法停止，造成内存泄漏。
class VCTimerThread: Thread {
    
    deinit {
        __devlog("VCTimerThread deinit")
    }
    
    private var port: Port?
    private var runLoop: RunLoop?
    private var isInited = false
    private var isStop = false
    private var isTimerStarted = false
    private(set) var countDownTime: TimeInterval = 0
    
    func startTimer() {
        if Thread.isMainThread || Thread.current == self {
            _startTimer()
        } else {
            exeInMultipleThreadSafety { [weak self] in
                self?._startTimer()
            }
        }
    }
    
    func stopTimer() {
        if Thread.isMainThread || Thread.current == self {
            _stopTimer()
        } else {
            exeInMultipleThreadSafety { [weak self] in
                self?._stopTimer()
            }
        }
    }
    
    func updateCountDownTime(with time: TimeInterval) {
        if Thread.isMainThread || Thread.current == self {
            _updateCountDownTime(time)
        } else {
            exeInMultipleThreadSafety { [weak self] in
                self?._updateCountDownTime(time)
            }
        }
    }
    
    @objc private func _updateCountDownTime(_ time: TimeInterval) {
        countDownTime = time
    }
    
    override func main() {
        _startThread()
    }
    
    private func _startThread() {
        guard !isInited else { return }
        isInited = true
        let runLoop = RunLoop.current
        let port = Port()
        self.port = port
        runLoop.add(port, forMode: RunLoop.Mode.default)
        self.runLoop = runLoop
        runLoop.run()
    }
    
    @objc private func _startTimer() {
        __devlog("_startTimer start")
        guard !isTimerStarted else {
            __devlog("_startTimer return")
            return
        }
        isTimerStarted = true
        isStop = false
        _addTimer()
        __devlog("_startTimer end")
    }
    
    @objc private func _stopTimer() {
        __devlog("_stopTimer start")
        guard !isStop else {
            __devlog("_stopTimer return")
            return
        }
        isStop = true
        isTimerStarted = false
        if let port = self.port {
            runLoop?.remove(port, forMode: RunLoop.Mode.default)
            self.port = nil
        }
        runLoop?.cancelPerformSelectors(withTarget: self)
        __devlog("_stopTimer end")
    }
    
    private func _addTimer() {
        guard !isStop else { return }
        guard let runLoop = self.runLoop else { return }
        let timer = Timer(timeInterval: 1, block: { [weak self] (_) in
            guard let SELF = self else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            __devlog("\(dateFormatter.string(from: Date()))")
            
            if !SELF.isStop {
                SELF._addTimer()
            }
            }, repeats: false)
        runLoop.add(timer, forMode: RunLoop.Mode.default)
    }
}
