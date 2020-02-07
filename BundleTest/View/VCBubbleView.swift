//
//  VCBubbleView.swift
//  Swift-iOS-Demo
//
//  Created by jianli chen on 2018/10/11.
//  Copyright © 2018年 jianli chen. All rights reserved.
//

import UIKit
import SnapKit
import YYCategories

/// 打点的气泡View
class VCBubbleView: UIView {
    
    private let bubbleFont = UIFont.systemFont(ofSize: 10)
    /// 气泡数
    private var bubbleDotCountStr = ""
    /// 气泡数字Label
    private lazy var bubbleDotCountView: UILabel = UILabel()
    /// 渐变色layer
    private lazy var gradualColorView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.creatNormalGradualImage(.noCorner)
        imageView.layer.masksToBounds = true
        self.insertSubview(imageView, at: 0)
        return imageView
    }()
    /// 容器view[用于切角]
    private lazy var containerView: UIView = UIView()
    
    
    /// 因为数字显示规则不一致，故数字字符串由外部传入
    func changeDotCount(_ count: String) {
        if count.isEmpty || count == "0" {
            isHidden = true
            return
        }
        isHidden = false
        bubbleDotCountStr = count
        var countWidth: CGFloat = bubbleDotCountStr.width(with: bubbleFont, height: 16)
        countWidth = countWidth > 16 ? countWidth + 4 : 16
        containerView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: countWidth, height: frame.height))
        gradualColorView.layer.cornerRadius = containerView.size.height * 0.5
        gradualColorView.frame = CGRect(origin: CGPoint.zero, size: containerView.size)
        bubbleDotCountView.text = bubbleDotCountStr
        containerView.layer.cornerRadius = containerView.frame.height * 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    private func setupUI() {
        setContainerView()
        setBubbleDotCountView()
    }
    
    private func setContainerView() {
        addSubview(containerView)
        containerView.layer.masksToBounds = true
        containerView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
    }
    
    private func setBubbleDotCountView() {
        containerView.addSubview(bubbleDotCountView)
        bubbleDotCountView.font = bubbleFont
        bubbleDotCountView.textColor = .white
        bubbleDotCountView.backgroundColor = .clear
        bubbleDotCountView.textAlignment = .center
        bubbleDotCountView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension String {
    
    /// 根据固定的size和font计算文字的height
    func height(with font: UIFont, size: CGSize) -> CGFloat {
        return self.rect(with: font, size: size).height
    }
    /// 根据固定的size和font计算文字的width
    func width(with font: UIFont, size: CGSize) -> CGFloat {
        return self.rect(with: font, size: size).width
    }
    
    /// 根据固定的height和font计算文字的width
    func width(with font: UIFont, height: CGFloat) -> CGFloat {
        return self.width(with: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
    }
    
    func rect(with font: UIFont, size: CGSize) -> CGRect {
        return (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
    
}

extension UIImage {
    class func creatNormalGradualImage(_ style: VCGradualStyle) -> UIImage {
        let imageCenterY = style.image.size.height / 2
        let imageCenterX = style.image.size.width / 2
        return style.image.resizableImage(withCapInsets: UIEdgeInsets(top: imageCenterY, left: imageCenterX, bottom: imageCenterY, right: imageCenterX), resizingMode: .stretch)
    }
}

enum VCGradualStyle: String {
    case noCorner = "bg_gradual_right_corner" // 直角
    case haveCorner = "bg_gradual_fillet_corner" // 圆角
    case cornerAndShadow = "bg_gradual_shadow" // 圆角有阴影
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}


