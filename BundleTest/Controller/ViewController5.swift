//
//  ViewController5.swift
//  BundleTest
//
//  Created by jianli chen on 2019/5/10.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit
import Foundation

class ViewController5: UIViewController {
    
    @IBOutlet weak var signBoxView: VCSignBoxView!
    
    private var timerThread: VCTimerThread?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let thread = VCTimerThread()
//        timerThread = thread
//        thread.start()
        
//        let format = DateFormatter()
//        let dateFormat = "yyyy-MM-dd HH:mm:ss"
//        format.dateFormat = dateFormat
//        if let date1 = format.date(from: "2019-05-21 18:50:00") {
//            let date11 = date1.convertToCurrentTimeZone()
//            print(date11)
//            print(date1.convertToString(dateFormat))
//            if let date2 = format.date(from: "2019-05-22 18:50:00") {
//                let date22 = date2.convertToCurrentTimeZone()
//                print(date22)
//                print(date2.convertToString(dateFormat))
//            }
//        }
    }
    
    @IBAction func onSleepBtnTapped(_ sender: Any) {
//        startTimer()
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let contentView = VCInterceptUIView()
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.68)
        contentView.layer.opacity = 0.5
        contentView.frame = window.bounds
        window.addSubview(contentView)
    }
    
    @objc fileprivate func startTimer() {
        DispatchQueue.global().async { [weak self] in
            self?.timerThread?.startTimer()
        }
        DispatchQueue.global().async { [weak self] in
            self?.timerThread?.startTimer()
        }
    }

    @IBAction func onStopBtnTapped(_ sender: Any) {
        DispatchQueue.global().async { [weak self] in
            self?.timerThread?.stopTimer()
        }
        DispatchQueue.global().async { [weak self] in
            self?.timerThread?.stopTimer()
        }
    }
    
    deinit {
        timerThread?.stopTimer()
    }
    
}
