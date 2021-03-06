//
//  VCLoadFromNibBaseView.swift
//  WeiboDongman
//
//  Created by jianli chen on 2019/3/28.
//  Copyright © 2019 Gookee. All rights reserved.
//

import UIKit
import Foundation

// 从xib中加载视图的视图基类
class VCLoadFromNibBaseView: UIView {
    
    weak var mainContainerView: UIView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        initialize()
    }
    
    init() {
        super.init(frame: .zero)
        loadFromNib()
        initialize()
    }
    
    func initialize() {
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let mainView = mainContainerView else {
            return super.hitTest(point, with: event)
        }
        
        if mainView != self {
            let cPoint = mainView.convert(point, from: self)
            if let view = mainView.hitTest(cPoint, with: event) {
                return view
            }
        }
        
        if let btn = self.subviews.first as? UIButton {
            return btn.hitTest(point, with:event)
        }
        
        return super.hitTest(point, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let mainView = mainContainerView else {
            return super.point(inside: point, with: event)
        }
        
        if mainView != self {
            let cPoint = mainView.convert(point, from: self)
            if mainView.point(inside: cPoint, with: event) {
                return true
            }
        }
        
        if let btn = self.subviews.first as? UIButton {
            return btn.point(inside: point, with: event)
        }
        
        return super.point(inside: point, with: event)
    }
}

// https://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
extension UIView {
    
    @discardableResult   // 1
    func loadFromNib<T : UIView>(completion: (() -> Void)? = nil) -> T? {   // 2
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {    // 3
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)     // 4
        contentView.translatesAutoresizingMaskIntoConstraints = false   // 5
        contentView.layoutAttachAll()   // 6
        completion?()
        return contentView   // 7
    }
}

extension UIView {
    
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(to margin: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: margin)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
}
