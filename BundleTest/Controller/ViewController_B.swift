//
//  ViewController_B.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/20.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class ViewController_B: UIViewController {
    
    class func viewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCID_B")
    }
    
    var timerSelf: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            timerSelf = Timer(timeInterval: 1.0, repeats: true, block: { (timer) in
                print("TEST: timerSelf \(timer) | \(Date())")
            })
//            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
//            timer.fire()
            
//            var obj = NSObject()
            
//            let observer = DeinitBindObserver { [weak self] in
//                print("TEST: 2")
//                timer.fire()
//                timer.invalidate()
//                obj.accessibilityActivate()
//                guard let SELF = self else {
//                    print("TEST: 1")
//                    return
//                }
//                print("TEST: 5")
////                timer = nil
//            }
//            observer.bind(to: self)
            
            
            
//            let observer = DeinitBindObserver<DispatchSourceTimer>({ [weak self] () -> DispatchSourceTimer? in
////                let timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
////                    print("TEST: \(timer) | \(Date()) | \(self)")
////                    self?.timerSelf?.fire()
////                })
////                RunLoop.main.add(timer, forMode: .commonModes)
////                print("TEST: 1 \(timer)")
////                return timer
//                guard let SELF = self else { return nil }
//                let timerAfter = after(5.0) { [weak SELF] in
//                    SELF?.timerSelf?.fire()
//                }
//                return timerAfter
//
//            }) { (timer) in
//                print("TEST: 3 \(timer)")
////                timer?.invalidate()
//                timer?.cancel()
//            }.bind(to: self)
            
            DeinitBindObserver<DispatchSourceTimer>({ [unowned self] () -> DispatchSourceTimer? in
                print("TEST: create 1")
                print("TEST: create return")
                return after(5.0) { [weak self] in
                    print("TEST fired.")
                    self?.timerSelf?.fire()
                }
            }) { [weak self] (timer) in
                print("TEST: block 3 | \(self)")
                timer?.cancel()
//                timer?.cancel()
            }.bind(to: self)
            
//            DeinitBindObserver<Void>({ [weak self] () -> Void? in
//                print("TEST: create 1")
//                guard let SELF = self else {
//                    print("TEST: create 2")
//                    return nil
//                }
//                print("TEST: create return")
//                after(3.0) { [weak SELF] in
//                    print("TETS fired.")
//                    SELF?.timerSelf?.fire()
//                }
//                return nil
//            }) { (_) in
//                print("TEST: block 3")
//                //                timer?.cancel()
//                }.bind(to: self)
        } else {
            
        }
    }
    
    @objc fileprivate func timerFired(_ timer: Timer) {
        print("TEST: 4 \(timer) | \(Date())")
    }
    
    deinit {
//        print("TEST: 3 \(timer?.isValid) | \(timer)")
        print("TEST: deinit deinit deinit deinit 4444")
    }
    
    @IBAction func onBackBtnTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
}



@discardableResult
func after(_ delta: TimeInterval, callFunc: @escaping ()->()) -> DispatchSourceTimer? {
    var timer: DispatchSourceTimer?
    timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer?.schedule(deadline: .now() + Double(delta))
    timer?.setEventHandler(handler: {
        callFunc()
    })
    timer?.resume()
    return timer
}
