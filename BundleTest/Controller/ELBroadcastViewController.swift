//
//  ELBroadcastViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/9.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

class ELBroadcastViewController: UIViewController {
    
//    fileprivate var dataSources: [String] = ["第 1 条"]
//    fileprivate var dataSources: [String] = ["第 1 条", "第 2 条"]
    fileprivate var dataSources: [String] = ["第 1 条", "第 2 条", "第 3 条"]
//    fileprivate var dataSources: [String] = ["第 1 条", "第 2 条", "第 3 条", "第 4 条"]
//    fileprivate var dataSources: [String] = ["第 1 条", "第 2 条", "第 3 条", "第 4 条", "第 5 条"]
//    fileprivate var dataSources: [String] = ["第 1 条", "第 2 条", "第 3 条", "第 4 条", "第 5 条", "第 6 条"]
    
    fileprivate var _broadcastView: ELBroadcastView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let margin: CGFloat = 16.0
        let height:CGFloat = 80.0
        
        let x: CGFloat = margin
        var y: CGFloat = 120.0
        
        let options: [ELBroadcastViewOption] = [
            ELBroadcastViewOption(2, direction: .bottomToUp, dutation: 2.0),
//            ELBroadcastViewOption(3, direction: .upToBottom, dutation: 2.0),
//            ELBroadcastViewOption(1, direction: .leftToRight, dutation: 3.0),
//            ELBroadcastViewOption(4, direction: .rightToLeft, dutation: 4.0)
        ]
        
        for index in 0 ..< options.count {
            let _broadcastView = ELBroadcastView(frame: .zero)
            _broadcastView.options = options[index]
            _broadcastView.dataSource = self
            _broadcastView.frame = CGRect.init(x: x,
                                               y: y,
                                               width: view.frame.size.width - 2 * margin,
                                               height: height)
            _broadcastView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                               UIView.AutoresizingMask.flexibleTopMargin,
                                               UIView.AutoresizingMask.flexibleBottomMargin,
                                               UIView.AutoresizingMask.flexibleLeftMargin,
                                               UIView.AutoresizingMask.flexibleRightMargin]
            _broadcastView.translatesAutoresizingMaskIntoConstraints = true
            _broadcastView.tappedBlock = {
                print("tapped...")
            }
            
            _broadcastView.layer.borderColor = UIColor.red.cgColor
            _broadcastView.layer.borderWidth = 1.0
            
            view.addSubview(_broadcastView)
            
            y += height + 30
            
            self._broadcastView = _broadcastView
        }
        
        
    }
    
    @IBAction func onReloadDataBtnTapped(_ sender: Any) {
        dataSources = ["第 1 条", "第 2 条", "第 3 条", "第 4 条", "第 5 条", "第 6 条"]
        _broadcastView?.reloadData()
    }
    

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}

extension ELBroadcastViewController: ELBroadcastViewDataSource {
    var elAutoScrollBroadcastDataSourceCount: Int {
        return dataSources.count
    }
    
    func elAutoScrollBroadcast(view: ELBroadcastView, viewForIndex index: Int) -> UIView {
        print("elAutoScrollBroadcast ?? \(index)")
        let text = dataSources[index % dataSources.count]
        let label = UILabel()
        label.textColor = .black
        label.text = text
        
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        
        
        return label
    }
}
