//
//  VCBaseTableViewController.swift
//  VComicApp
//
//  Created by 杨权 on 2017/7/12.
//  Copyright © 2017年 Gookee. All rights reserved.
//

import UIKit

class VCBaseTableViewController: UITableViewController, VCViewControllerRequestContentProtocol {
    
    var pulldownCount: Int = 0
    var pullupCount: Int = 0
    var isContentEmpty: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationBarStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarIsTranslucent()
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        AppContext.shared.viewSafeAreaCompat = viewSafeAreaInsets
    }
    
    func requestContent(_ isRefresh: Bool, type: VCPageDataRequestType = .default) {
        
    }

    // MARK: - 关于旋转的一些配置和说明
    // _xxx_ 系列方法，由子类自定义实现，未实现时，使用下面的默认参数
    var _preferredStatusBarStyle_: UIStatusBarStyle? { return nil }
    var _prefersStatusBarHidden_: Bool? { return nil }
    var _shouldAutorotate_: Bool? { return nil }
    var _supportedInterfaceOrientations_: UIInterfaceOrientationMask? { return nil }
    var _preferredInterfaceOrientationForPresentation_: UIInterfaceOrientation? { return nil }

    // 1.如果存在presentedViewController，并且正在被present，则优先使用presentedViewController的配置参数
    // 2.如果存在presentedViewController，并且正在被dismiss，则优先使用当前控制器的参数配置，如果子类没有重写对应的系列_xxx_方法，则使用默认参数
    // 3.如果存在presentedViewController（说明它当前正在被显示），则优先使用presentedViewController的配置参数
    // 4.最后，使用子类自定义(如果子类有重写对应的系列_xxx_方法)或默认配置

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let presentedController = presentedViewController, presentedController.isBeingPresented {
            return presentedController.preferredStatusBarStyle
        }
        if let presentedController = presentedViewController, presentedController.isBeingDismissed {
            return _preferredStatusBarStyle_ ?? kDefaultPreferredStatusBarStyle
        }
        if let presentedController = presentedViewController {
            return presentedController.preferredStatusBarStyle
        }
        return _preferredStatusBarStyle_ ?? kDefaultPreferredStatusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        if let presentedController = presentedViewController, presentedController.isBeingPresented {
            return presentedController.prefersStatusBarHidden
        }
        if let presentedController = presentedViewController, presentedController.isBeingDismissed {
            return _prefersStatusBarHidden_ ?? kDefaultPrefersStatusBarHidden
        }
        if let presentedController = presentedViewController {
            return presentedController.prefersStatusBarHidden
        }
        return _prefersStatusBarHidden_ ?? kDefaultPrefersStatusBarHidden
    }

    override var shouldAutorotate: Bool {
        if let presentedController = presentedViewController, presentedController.isBeingPresented {
            return presentedController.shouldAutorotate
        }
        if let presentedController = presentedViewController, presentedController.isBeingDismissed {
            return _shouldAutorotate_ ?? kDefaultShouldAutorotate
        }
        if let presentedController = presentedViewController {
            return presentedController.shouldAutorotate
        }
        return _shouldAutorotate_ ?? kDefaultShouldAutorotate
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let presentedController = presentedViewController, presentedController.isBeingPresented {
            return presentedController.supportedInterfaceOrientations
        }
        if let presentedController = presentedViewController, presentedController.isBeingDismissed {
            return _supportedInterfaceOrientations_ ?? kDefaultSupportedInterfaceOrientations
        }
        if let presentedController = presentedViewController {
            return presentedController.supportedInterfaceOrientations
        }
        return _supportedInterfaceOrientations_ ?? kDefaultSupportedInterfaceOrientations
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentedController = presentedViewController, presentedController.isBeingPresented {
            return presentedController.preferredInterfaceOrientationForPresentation
        }
        if let presentedController = presentedViewController, presentedController.isBeingDismissed {
            return _preferredInterfaceOrientationForPresentation_ ?? kDefaultPreferredInterfaceOrientationForPresentation
        }
        if let presentedController = presentedViewController {
            return presentedController.preferredInterfaceOrientationForPresentation
        }
        return _preferredInterfaceOrientationForPresentation_ ?? kDefaultPreferredInterfaceOrientationForPresentation
    }

}
