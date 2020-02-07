//
//  NSAttributedString+Extension.swift
//  BundleTest
//
//  Created by jianli chen on 2019/9/20.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation

extension NSAttributedString {
    func bound(for width: CGFloat) -> CGSize {
        let bounds = boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        return bounds.size
    }
}
