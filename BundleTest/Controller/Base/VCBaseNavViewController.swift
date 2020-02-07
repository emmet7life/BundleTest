//
//  VCBaseNavViewController.swift
//  VComicApp
//
//  Created by 杨权 on 2017/7/12.
//  Copyright © 2017年 Gookee. All rights reserved.
//

import UIKit

class VCBaseNavViewController: UINavigationController {
    
    deinit {
        delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        AppContext.shared.viewSafeAreaCompat = viewSafeAreaInsets
    }

    func resetNavBarTheme() {
        UINavigationBar.appearance().isTranslucent = topViewController?.isNavigationBarTransparent ?? true
        UINavigationBar.appearance().setBackgroundImage(defaultNavBarBackgroundImage, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage.defaultShadowImage
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemMediumFont(18), NSAttributedString.Key.foregroundColor : UIColor.mainColor]
    }
}

extension VCBaseNavViewController {

    override var shouldAutorotate: Bool {
        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingPresented {
            return presentedViewController?.shouldAutorotate ?? kDefaultShouldAutorotate
        }

        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingDismissed {
            return topViewController?.shouldAutorotate ?? kDefaultShouldAutorotate
        }
        return visibleViewController?.shouldAutorotate ?? kDefaultShouldAutorotate
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingPresented {
            return presentedViewController?.supportedInterfaceOrientations ?? kDefaultSupportedInterfaceOrientations
        }

        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingDismissed {
            return topViewController?.supportedInterfaceOrientations ?? kDefaultSupportedInterfaceOrientations
        }

        return visibleViewController?.supportedInterfaceOrientations ?? kDefaultSupportedInterfaceOrientations
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingPresented {
            return presentedViewController?.preferredInterfaceOrientationForPresentation ?? kDefaultPreferredInterfaceOrientationForPresentation
        }

        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingDismissed {
            return topViewController?.preferredInterfaceOrientationForPresentation ?? kDefaultPreferredInterfaceOrientationForPresentation
        }

        return visibleViewController?.preferredInterfaceOrientationForPresentation ?? kDefaultPreferredInterfaceOrientationForPresentation
    }

    override var prefersStatusBarHidden: Bool {
        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingPresented {
            return presentedViewController?.prefersStatusBarHidden ?? kDefaultPrefersStatusBarHidden
        }

        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingDismissed {
            return topViewController?.prefersStatusBarHidden ?? kDefaultPrefersStatusBarHidden
        }

        return visibleViewController?.prefersStatusBarHidden ?? kDefaultPrefersStatusBarHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingPresented {
            return presentedViewController?.preferredStatusBarStyle ?? kDefaultPreferredStatusBarStyle
        }

        if let presentedController = topViewController?.presentedViewController, presentedController.isBeingDismissed {
            return topViewController?.preferredStatusBarStyle ?? kDefaultPreferredStatusBarStyle
        }

        return visibleViewController?.preferredStatusBarStyle ?? kDefaultPreferredStatusBarStyle
    }

}

extension VCBaseNavViewController: UINavigationControllerDelegate {

    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return supportedInterfaceOrientations
    }

    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return preferredInterfaceOrientationForPresentation
    }

}

extension VCBaseNavViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 播放器处于横屏时，禁用左滑手势
        if let controller = topViewController, controller.isForbidInteractivePopGesture {
            return false
        }
        return viewControllers.count > 1
    }

}
