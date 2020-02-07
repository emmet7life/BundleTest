//
//  ELUIUtils.swift
//  BundleTest
//
//  Created by jianli chen on 2019/11/11.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation
import Lottie

class ELUIUtils {
    static var _cachedLottieJsonResources: [String: [String: AnyHashable]] = [:]
    
    // 创建Lottie组件
    class func createLottieAnimateView(with bundleName: String) -> LOTAnimationView? {
        if let bundle = Bundle.vc_customBundle(with: bundleName) {
            // 优先使用缓存数据
            if let dataJson = ELUIUtils._cachedLottieJsonResources[bundleName] {
                return LOTAnimationView(json: dataJson, bundle: bundle)
            }
            
            if let dataPath = bundle.path(forResource: "data", ofType: "json") {
                let dataURL = URL(fileURLWithPath: dataPath)
                if let data = try? Data(contentsOf: dataURL) {
                    if let dataJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyHashable], let validJson = dataJson {
                        // 缓存
                        ELUIUtils._cachedLottieJsonResources.updateValue(validJson, forKey: bundleName)
                        return LOTAnimationView(json: validJson, bundle: bundle)
                    }
                }
            }
        }
        return nil
    }
}
