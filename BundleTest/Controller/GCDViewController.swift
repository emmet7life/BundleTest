//
//  GCDViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/7/20.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class GCDViewController: UIViewController {
    
    let barrier: DispatchQueue = DispatchQueue.init(label: "GCDViewController_Barrier_Queue", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        perform(#selector(doDelay(_:)), with: 1, afterDelay: 4.0, inModes: [RunLoopMode.commonModes])
//        perform(#selector(doDelay(_:)), with: 1, afterDelay: 4.0, inModes: [RunLoopMode.defaultRunLoopMode])
//        perform(#selector(doDelay(_:)), with: 1, afterDelay: 4.0)
//        RunLoop.current.perform(#selector(doDelay(_:)), target: self, argument: 1, order: 0, modes: [RunLoopMode.commonModes])
    }
    
    @objc fileprivate func doDelay(_ argument: Any?) {
        print("doDelay invoked wity \(String(describing: argument)) on Thread: \(Thread.current)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButton1Tapped(_ sender: Any) {
//        doTask("MainThread")
//        Thread.detachNewThreadSelector(#selector(doTask(_:)), toTarget: self, with: "NotMainThread")
        print("onButton1Tapped")
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doDelay(_:)), object: 1)
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
//        RunLoop.current.cancelPerform(#selector(doDelay(_:)), target: self, argument: 1)
        
    }
    
    @objc fileprivate func doTask(_ flag: String = "OtherThread") {
        print("\(flag) : \(Thread.current.debugDescription) tapped ______________1")
        
        barrier.async {
            print("\(flag) : A \(Thread.current.debugDescription) start")
            Thread.sleep(forTimeInterval: 2.0)
            print("\(flag) : A \(Thread.current.debugDescription) end")
        }
        
        barrier.async {
            print("\(flag) : B \(Thread.current.debugDescription) start")
            Thread.sleep(forTimeInterval: 2.0)
            print("\(flag) : B \(Thread.current.debugDescription) end")
        }
        
        print("\(flag) : \(Thread.current.debugDescription) tapped ______________2")
        
        barrier.sync(flags: .barrier) {
            print("\(flag) : C \(Thread.current.debugDescription) start")
            Thread.sleep(forTimeInterval: 2.0)
            print("\(flag) : C \(Thread.current.debugDescription) end")
        }
        
        print("\(flag) : \(Thread.current.debugDescription) tapped ______________3")
        
        barrier.async {
            print("\(flag) : D \(Thread.current.debugDescription) start")
            Thread.sleep(forTimeInterval: 2.0)
            print("\(flag) : D \(Thread.current.debugDescription) end")
        }
        
        print("\(flag) : \(Thread.current.debugDescription) tapped ______________4")
        
        barrier.sync(flags: .barrier) {
            print("\(flag) : E \(Thread.current.debugDescription) start")
            Thread.sleep(forTimeInterval: 2.0)
            print("\(flag) : E \(Thread.current.debugDescription) end")
        }
        
        print("\(flag) : \(Thread.current.debugDescription) tapped ______________5")
    }

}
