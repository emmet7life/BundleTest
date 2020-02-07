//
//  ELActivityBackgroundButton.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/4/18.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import Foundation
import UIKit

class ELActivityBackgroudnButton: UIButton {
    
    struct Options {
        
        var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        var isAutomaticLayout: Bool = true
        var titleFontSize: CGFloat = 14.0
        var titleColor: UIColor = .white
        var layoutFrame: CGRect = .zero
        
    }
    
    fileprivate let _backgroundTranslucentPadding: CGFloat = 20.0
    fileprivate(set) var meaturedSize: CGSize = .zero
    
    var options = Options() {
        didSet {
            updateContentIfNeeded()
        }
    }
    
    var title: String? = nil {
        didSet {
            if oldValue != title {
                updateContentIfNeeded()
            }
        }
    }
    
    init(_ options: Options, title: String) {
        super.init(frame: options.layoutFrame)
        self.options = options
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentIfNeeded()
    }
    
    fileprivate var _width: CGFloat {
        return bounds.size.width
    }
    
    fileprivate var _height: CGFloat {
        return bounds.size.height
    }
    
    fileprivate lazy var measureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.options.titleFontSize)
        return label
    }()
    
    fileprivate func measureSize(_ text: String) -> CGSize {
        let label = measureLabel
        let size = CGSize(width: CGFloat(MAXFLOAT), height: max(options.titleFontSize, _height))
        label.text = text
        return label.sizeThatFits(size)
    }
    
    fileprivate func mergeFrame(_ frame: CGRect, insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: frame.origin.x,
                      y: frame.origin.y,
                      width: frame.size.width + insets.left + insets.right + _backgroundTranslucentPadding * 2,
                      height: frame.size.height + insets.top + insets.bottom)
    }
    
    fileprivate func updateContentIfNeeded() {
        guard let title = self.title else { return }
        
        if meaturedSize == .zero {
            var helperImageView = UIImageView()
            let originalFrame = self.frame
            var frame = CGRect.zero
            let capInsets = UIEdgeInsets(top: 24, left: 30, bottom: 25, right: 43)
            var image = UIImage(named: "activity_background_btn_mask_layer")?.withRenderingMode(.alwaysOriginal).resizableImage(withCapInsets: capInsets, resizingMode: .tile)
            
            helperImageView.image = image
            helperImageView.sizeToFit()
            
            let minFrame = helperImageView.frame
            let size = measureSize(title)
            
            frame = mergeFrame(CGRect(origin: .zero, size: size), insets: options.edgeInsets)
            
            frame.size.width = max(minFrame.size.width, frame.size.width)
            frame.size.height = max(minFrame.size.height, frame.size.height)
            
            helperImageView.frame = frame
            helperImageView.layer.frame = frame
            
            let maskLayer = helperImageView.layer
            
            helperImageView = UIImageView()
            image = UIImage(named: "activity_background_btn_foreground_bg")?.withRenderingMode(.alwaysOriginal).resizableImage(withCapInsets: capInsets, resizingMode: .tile)
            helperImageView.image = image
            helperImageView.sizeToFit()
            
            helperImageView.frame = frame
            helperImageView.layer.frame = frame
            
            let sublayer = helperImageView.layer
            sublayer.removeFromSuperlayer()
            
            let backgroundImageView = UIImageView()
            backgroundImageView.image = UIImage(named: "activity_background_btn_background_bg")
            backgroundImageView.contentMode = .scaleToFill
            backgroundImageView.frame = frame
            addSubview(backgroundImageView)
            
            backgroundImageView.layer.addSublayer(sublayer)
            backgroundImageView.layer.mask = maskLayer
            
            self.frame = CGRect(origin: originalFrame.origin, size: frame.size)
            self.meaturedSize = frame.size
        }
        
        titleLabel?.textAlignment = .center
//        titleLabel?.textColor = options.titleColor
        titleLabel?.font = UIFont.systemFont(ofSize: options.titleFontSize)
        setTitle(title, for: UIControl.State())
        setTitleColor(options.titleColor, for: UIControl.State())
    }
    
    override var intrinsicContentSize: CGSize {
        return meaturedSize
    }
    
}
