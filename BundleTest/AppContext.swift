//
//  AppContext.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/25.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class AppContext {
    static let shared = AppContext()
    
    private init() {}
    
    var viewSafeAreaCompat: UIEdgeInsets = UIEdgeInsets.zero
}
