//
//  VCBaseTabBarController.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/11.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCBaseTabBarController: UITabBarController {
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? kDefaultPrefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? kDefaultPreferredStatusBarStyle
    }
    
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? kDefaultShouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [selectedViewController?.supportedInterfaceOrientations ?? kDefaultSupportedInterfaceOrientations, preferredInterfaceOrientationForPresentation.orientationMask]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? kDefaultPreferredInterfaceOrientationForPresentation
    }
}
