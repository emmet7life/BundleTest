//
//  DeinitBindObserver.swift
//  Swift-2018
//
//  Created by jianli chen on 2018/12/20.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation

private var kBindToListenerObserverDeinitKey: Void?

class DeinitBindObserver<T> {
    
    typealias DeinitActionCreateT = () -> T?
    typealias DeinitActionBlock = (T?) -> Void
    
    var deinitBlock: DeinitActionBlock? = nil
    var t: T? = nil
    
    init(_ create: DeinitActionCreateT, _ deinitBlock: @escaping DeinitActionBlock) {
        self.t = create()
        self.deinitBlock = deinitBlock
    }
    
    deinit {
        print("TEST DeinitBindObserver >> \(t)")
        deinitBlock?(t)
    }
    
    func bind(to obj: Any) {
        if (objc_getAssociatedObject(obj, &kBindToListenerObserverDeinitKey) as? DeinitBindObserver) == nil {
            objc_setAssociatedObject(obj, &kBindToListenerObserverDeinitKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
