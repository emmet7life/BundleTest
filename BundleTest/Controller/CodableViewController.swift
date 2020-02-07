//
//  CodableViewController.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/9/21.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
let screenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

class CodableViewController: UIViewController {

    fileprivate lazy var _tabMenu: ELTabMenu = ELTabMenu(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTabMenu()
//
//        if let button1 = view.viewWithTag(997) as? UIButton {
//            button1.isScaleDownEffectEnable = false
//        }
//
//        if let button2 = view.viewWithTag(998) as? UIButton {
//            button2.isScaleDownEffectEnable = true
//        }
        
        
    }
    
    /// 设置顶部滑动菜单
    private func setTabMenu() {
        _tabMenu.delegate = self
        var options = ELTabMenuOptions()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.colorWithHexRGBA(0xFF4D6A)
        backgroundView.layer.cornerRadius = _tabMenu.height * 0.5
        backgroundView.layer.masksToBounds = true
        
        let scrollBarHeight: CGFloat = _tabMenu.height - 2.0
        let scrollIndicatorView = UIView()
        scrollIndicatorView.backgroundColor = .white
        scrollIndicatorView.layer.cornerRadius = scrollBarHeight * 0.5
        scrollIndicatorView.layer.masksToBounds = true
        
//        scrollIndicatorView.layer.borderColor = UIColor.yellow.cgColor
//        scrollIndicatorView.layer.borderWidth = 1.5
        
        options.margin = 1
        options.padding = 5
        options.normalColor = .white
        
        options.backgroundView = backgroundView
        options.scrollIndicatorView = scrollIndicatorView
        
        options.scrollBarHeight = CGFloat(scrollBarHeight)
        options.scrollBarPositionOffset = -1.0
//        options.scrollBarWidth = 66.0
        
        options.edgeNeedMargin = true
        
        options.defaultItemIndex = 1
        options.isScrollBarAutoScrollWithOffsetChanged = true
        
        _tabMenu.options = options
        _tabMenu.isExclusiveTouch = true
        _tabMenu.tabTitles = ["关注", "热门"]
        
        navigationItem.titleView = _tabMenu
        if let _ = _tabMenu.superview, #available(iOS 11, *) {
            _tabMenu.snp.makeConstraints { (make) in
                make.width.equalTo(100)
                make.height.equalTo(30)
                make.center.equalToSuperview()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("DEBUG ?? 1 \(CACurrentMediaTime())")
//        perform(#selector(delaySelector), with: nil, afterDelay: 3.0)
        _tabMenu.addBubble(with: 0, count: 100)
        _tabMenu.addBubble(with: 1, count: 3)
        
    }
    
//    @objc fileprivate func delaySelector() {
//        print("DEBUG ?? 2 \(CACurrentMediaTime())")
//    }

}

extension CodableViewController: ELTabMenuDelegate {
    func switchToTab(_ index: Int, disable: Bool) {
        _tabMenu.scrollToTab(index, invokeDelegate: false)
    }
}
