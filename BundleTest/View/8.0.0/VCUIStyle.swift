//
//  VCUIStyle.swift
//  BundleTest
//
//  Created by jianli chen on 2019/7/15.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

// MARK: - UI样式
struct VCUIStyle {
    
    // 会员
    struct MemberSupplymentHeader {
        typealias TextOption = VCSuperMemberReuseHeaderView.TextOption
        // 默认样式组A
        static let defaultTitleOption1: TextOption = TextOption(textColor: UIColor.white, textFont: UIFont.systemMediumFont(18.0), top: 16.0, left: 16.0, right: 16.0, height: 25.0)
        static let defaultSubTitleOption1: TextOption = TextOption(textColor: UIColor.white, textFont: UIFont.systemMediumFont(12.0), top: 44.0, left: 16.0, right: 16.0, height: 18.0)
        
        // 默认样式组B
        static let defaultTitleOption2: TextOption = TextOption(textColor: UIColor.colorWithHexRGBA(0x404040), textFont: UIFont.systemMediumFont(18.0), top: 45.0, left: 16.0, right: 16.0, height: 25.0)
        static let defaultSubTitleOption2: TextOption = TextOption(textColor: UIColor.assitantColor, textFont: UIFont.systemMediumFont(12.0), top: 72.0, left: 16.0, right: 16.0, height: 18.0)
        
        // 创建自定义样式
        static func textOption(textColor: UIColor = UIColor.white, textFont: UIFont = UIFont.systemMediumFont(18.0),
                                top: CGFloat = 16.0, left: CGFloat = 16.0, right: CGFloat = 16.0, height: CGFloat = 25.0) -> TextOption {
            return TextOption(textColor: textColor, textFont: textFont, top: top, left: left, right: right, height: height)
        }
    }
}
