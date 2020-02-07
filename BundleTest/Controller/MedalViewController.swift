//
//  MedalViewController.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/11/20.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import Kingfisher

class MedalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let size = ProcessInfo.processInfo.physicalMemory
//        print("physicalMemory is \(size/1024/1024)")
//
//        NotificationCenter.default.addObserver(self, selector: #selector(oberser), name: NSNotification.Name("ZYNetworkAccessibityChangedNotification"), object: nil)
        
//        if let label = view.viewWithTag(999) as? UILabel {
//            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
//                .strokeColor : UIColor.yellow,
//                .foregroundColor : UIColor.white,
//                .strokeWidth : 6.0,
//                ]
//            label.attributedText = NSAttributedString(string: "22", attributes: strokeTextAttributes)
//        }
//        label?.layer.shadowColor = UIColor.yellow.cgColor
//        label?.layer.shadowOffset = CGSize(width: 0, height: 0)
//        label?.layer.shadowRadius = 2.0
//        label?.layer.shadowOpacity = 1.0
        
        let medalButton1 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.small)
        medalButton1.frame = CGRect(x: 20, y: 100, width: 0, height: 0)
        medalButton1.medalLevel = 0
        view.addSubview(medalButton1)

        let medalButton2 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.small)
        medalButton2.frame = CGRect(x: 20, y: 150, width: 0, height: 0)
        medalButton2.medalLevel = 12
        view.addSubview(medalButton2)

        let medalButton3 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.small)
        medalButton3.frame = CGRect(x: 20, y: 200, width: 0, height: 0)
        medalButton3.medalLevel = 123
        view.addSubview(medalButton3)

        let medalButton4 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.big)
        medalButton4.frame = CGRect(x: 100, y: 100, width: 0, height: 0)
        medalButton4.medalLevel = 0
        view.addSubview(medalButton4)

        let medalButton5 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.big)
        medalButton5.frame = CGRect(x: 100, y: 150, width: 0, height: 0)
        medalButton5.medalLevel = 12
        view.addSubview(medalButton5)

        let medalButton6 = VCMedalLevelButton(style: VCMedalLevelButton.MedalButtonStyle.big)
        medalButton6.frame = CGRect(x: 100, y: 200, width: 0, height: 0)
        medalButton6.medalLevel = 123
        view.addSubview(medalButton6)
//
//        let layoutInfo: VCMedalLevelButton.MedalButtonLayoutInfo = (CGSize(width: 50, height: 27), CGSize(width: 50, height: 27), CGPoint(x: 22, y: 8), CGSize(width:27, height: 16), UIFont.boldSystemFont(ofSize: 12), UIColor.colorWithHexRGBA(0xD37828), UIColor.colorWithHexRGBA(0x999999), NSTextAlignment.center, nil, nil)
//        let medalButtonCustom = VCMedalLevelButton(style: .custom(layoutInfo))
//        medalButtonCustom.medalIcon = "levelBG"
//        medalButtonCustom.medalGrayIcon = "levelBG_gray"
//        medalButtonCustom.frame = CGRect(x: 200, y: 200, width: 0, height: 0)
//        medalButtonCustom.medalLevel = 100
//        view.addSubview(medalButtonCustom)
//        let constraints = [
//            NSLayoutConstraint(item: medalButton2, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 200),
//            NSLayoutConstraint(item: medalButton2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 100),
//            NSLayoutConstraint(item: medalButton2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200),
//            NSLayoutConstraint(item: medalButton2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 200),
//        ]
//        medalButton2.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraints(constraints)
        
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
//
//        let medalsView = VCMedalsView()
//        medalsView.frame = CGRect(origin: CGPoint(x: 10, y: 500), size: CGSize(width: 150, height: 24))
//        medalsView.backgroundColor = .yellow
//        view.addSubview(medalsView)
//
//        let medalInfo1 = VCMedalInfo(id: "1", icon: "https://img12.360buyimg.com/n7/jfs/t25786/193/2405899808/361096/49664b1b/5be4f06aN4c846175.jpg")
//        let medalInfo2 = VCMedalInfo(id: "2", icon: "https://img12.360buyimg.com/n7/jfs/t1/5849/19/2729/107447/5b975eb0Ec615051e/eeb34950512bdada.jpg")
//        let medalInfo3 = VCMedalInfo(id: "3", icon: "https://img12.360buyimg.com/n7/jfs/t21028/139/2654301809/291169/231c2030/5b602aa8N83cdf710.jpg")
//        medalsView.setSourceMedals(with: [medalInfo1, medalInfo2, medalInfo3])
        
        
        func calculate(val: Double, format: String) -> String {
            let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 1, raiseOnExactness: false,
                                                        raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let ouncesDecimal = NSDecimalNumber(value: val)
            let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: decimalHandler)
            return NSString(format: format as NSString, roundedOunces.floatValue) as String
        }
        
        let s1 = calculate(val: 1, format: "%.1f")
        print(s1)
        let s2 = calculate(val: 1.0, format: "%.1f")
        print(s2)
        let s3 = calculate(val: 1.09, format: "%.1f")
        print(s3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc fileprivate func oberser() {
        let state = ZYNetworkAccessibity.currentState()
        print("VCNetworkDetecter state is >>> 2 \(state)")
    }
    
    @IBAction func onButtnTapped(_ sender: Any) {
//        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationReceiver(_:)), name: NSNotification.Name("AAA"), object: nil)
//        Thread.detachNewThreadSelector(#selector(postANotification(_:)), toTarget: self, with: nil)
        
        let viewController = ViewController_SafeArea() //ViewController_B.viewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc fileprivate func postANotification(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("AAA"), object: nil)
    }
    
    @objc fileprivate func onNotificationReceiver(_ notification: Notification) {
        print("Thread is \(Thread.current)")
    }

}

