//
//  Notification+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/11/7.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

func addNCObserver(_ observer: Any, _ selector: Selector, _ name: NSNotification.Name, _ object: Any? = nil) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
}

func addNCObserver(_ observer: Any, _ selector: Selector, _ name: String, _ object: Any? = nil) {
    addNCObserver(observer, selector, NSNotification.Name(rawValue: name), object)
}

func removeNCObserver(_ observer: Any, _ name: NSNotification.Name, _ object: Any? = nil) {
    NotificationCenter.default.removeObserver(observer, name: name, object: object)
}

func removeNCObserver(_ observer: Any, _ name: String, _ object: Any? = nil) {
    removeNCObserver(observer, NSNotification.Name(rawValue: name), object)
}

func removeAllNCObserver(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
}

func postNotification(_ name: String, _ object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: NSNotification.Name(name), object: object, userInfo: userInfo)
}
