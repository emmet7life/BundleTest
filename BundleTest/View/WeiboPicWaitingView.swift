//
//  WeiboPicWaitingView.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/5/4.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit

enum WaitingViewProgressMode {
    case loopDiagram
    case pieDiagram
}

struct WeiboPicsViewerMacro {
    
    static let kMinZoomScale: CGFloat = 1.0
    static let kMaxZoomScale: CGFloat = 2.0
    
    static let kCanSaveImageToUserPhotos = true
    
    static let kSaveImageSuccessText = "保存成功"
    static let kSaveImageFailedText = "保存失败"
    
    static let kViewerBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let kViewerShowImageAnimationDuration: TimeInterval = 0.35
    static let kViewerDismissImageAnimationDuration: TimeInterval = 0.35
    static let kViewerOrientationChangeViewAnimateDuration: TimeInterval = 0.35
    
    // 图片之间的间隔
    static let kPicsInteriItemSpacing: CGFloat = 10
    
    static var kWaitingViewProgressMode: WaitingViewProgressMode = .pieDiagram
    
    // 是否在横屏的时候直接满宽度，而不是满高度，一般在有长图需求的时候设置为true
    static let kFullWidthForLandscape = true
    
    // 是否支持横屏
    static let kShouldSupportLandscape = true
    
    static let kAppWidth: CGFloat = UIScreen.main.bounds.width
    static let kAppHeight: CGFloat = UIScreen.main.bounds.height
    
    static let kWaitingViewBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    static let kWaitingViewInnerPadding: CGFloat = 2
    
}

// MARK: WeiboPicWaitingView
class WeiboPicWaitingView: UIView {
    
    fileprivate(set) var _progress: CGFloat = 0.1
    fileprivate var _fillColorAlpha: CGFloat = 1.0
    
    var mode = WeiboPicsViewerMacro.kWaitingViewProgressMode
    
    convenience init(frame: CGRect = CGRect(x: 0, y: 0, width: 41, height: 41), mode: WaitingViewProgressMode = .pieDiagram) {
        self.init(frame: frame)
        self.mode = mode
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    override var frame: CGRect {
        didSet {
            var _frame = frame
            let width = _frame.width
            if width != _frame.height {
                _frame.size = CGSize(width: width, height: width)
            }
            layer.cornerRadius = width * 0.5
            super.frame = _frame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: CGFloat) {
        // adjust
        if progress < 0 {
            _progress = 0.0
        } else if progress > 1.0 {
            _progress = 1.0
        } else {
            _progress = progress
        }
        setNeedsDisplay()
    }
    
    func setFillColorAlpha(_ alpha: CGFloat) {
        print("setFillColorAlpha >> \(alpha)")
        _fillColorAlpha = alpha
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1.0
        
        let xCenter = rect.size.width * 0.5
        let yCenter = rect.size.height * 0.5
        
        switch mode {
        case .pieDiagram:
            
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)//WeiboPicsViewerMacro.kWaitingViewBackgroundColor
            UIColor(red: 1, green: 1, blue: 1, alpha: _fillColorAlpha).set()
            
            let radius = min(xCenter, yCenter) - WeiboPicsViewerMacro.kWaitingViewInnerPadding
//
//            let w = radius * 2 + WeiboPicsViewerMacro.kWaitingViewInnerPadding
//            let h = w
//            let x = (rect.size.width - w) * 0.5
//            let y = (rect.size.height - h) * 0.5
//            ctx.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
            
            ctx.addPath(UIBezierPath(ovalIn: bounds).cgPath)
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.strokePath()
            
            UIColor.white.set()
            ctx.move(to: CGPoint(x: xCenter, y: yCenter))
            ctx.addLine(to: CGPoint(x: xCenter, y: 0))
            let to = -CGFloat(Double.pi) * 0.5 + _progress * CGFloat(Double.pi) * 2.0 + 0.001
            //            CGContextAddArc(ctx, xCenter, yCenter, radius, -CGFloat(M_PI) * 0.5, to, 1)
            ctx.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: to, clockwise: false)
            ctx.closePath()

            ctx.fillPath()
            
        case .loopDiagram:
            let lineWidth: CGFloat = 6.0
            backgroundColor = .clear
            UIColor.white.withAlphaComponent(0.88).set()
            ctx.setLineWidth(lineWidth)
            ctx.setLineCap(CGLineCap.round)
            let to2 = -CGFloat(Double.pi) * 0.5 + 1.0 * CGFloat(Double.pi) * 2.0 + 0.05
            let radius2 = min(xCenter, yCenter) - lineWidth * 0.5
            ctx.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius2, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: to2, clockwise: false)
            ctx.strokePath()
            
            UIColor.colorWithHexRGBA(0xff496c).withAlphaComponent(0.98).set()
            ctx.setLineWidth(lineWidth)
            ctx.setLineCap(CGLineCap.round)
            let to = -CGFloat(Double.pi) * 0.5 + _progress * CGFloat(Double.pi) * 2.0 + 0.05
            let radius = min(xCenter, yCenter) - lineWidth * 0.5
            ctx.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: to, clockwise: false)
            ctx.strokePath()
            
            break
        }
    }
    
    
}
