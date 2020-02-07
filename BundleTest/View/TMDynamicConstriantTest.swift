//
//  TMDynamicConstriantTest.swift
//  BundleTest
//
//  Created by jianli chen on 2019/8/23.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import Foundation
import SnapKit

class TMDynamicConstriantTestView: UIView {
    
    private(set) var label1 = UILabel()
    private(set) var label2 = UILabel()
    private(set) var label3 = UILabel()
    private(set) var image = UIImageView()
    
    private var label1Trailing2Label2Constraint: Constraint?
    private var label2Trailing2Label3Constraint: Constraint?
    private var label3Trailing2ImageConstraint: Constraint?
    private var imageWidthConstraint: Constraint?
    private var imageHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBaseView()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupBaseView() {
        
        label1.textAlignment = .center
        label2.textAlignment = .left
        label3.textAlignment = .left
        
        label1.numberOfLines = 0
        
        label1.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        label2.setContentCompressionResistancePriority(UILayoutPriority(751), for: NSLayoutConstraint.Axis.horizontal)
        label3.setContentCompressionResistancePriority(UILayoutPriority(752), for: NSLayoutConstraint.Axis.horizontal)
        image.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        
        label1.font = UIFont.systemMediumFont(13)
        label2.font = UIFont.systemMediumFont(11)
        label3.font = UIFont.systemMediumFont(9)
        image.contentMode = .scaleAspectFit
        image.image = nil
        
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
//        addSubview(image)
        
        label1.backgroundColor = UIColor.red
        label2.backgroundColor = UIColor.yellow
        label3.backgroundColor = UIColor.green
        image.backgroundColor = UIColor.blue
        
        label1.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.bottom.equalTo(-4)
            label1Trailing2Label2Constraint = make.trailing.equalTo(label2.snp.leading).offset(-8).constraint
        }
        
        label2.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4)
            label2Trailing2Label3Constraint = make.trailing.equalTo(label3.snp.leading).offset(-8).constraint
        }
        
        label3.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4)
            make.trailing.lessThanOrEqualTo(-8)
//            label3Trailing2ImageConstraint = make.trailing.equalTo(image.snp.leading).offset(-8).constraint
        }
        
//        image.snp.makeConstraints { (make) in
//            make.trailing.lessThanOrEqualTo(-8)
//            make.bottom.equalTo(-4)
//            imageWidthConstraint = make.width.equalTo(0).constraint
//            imageHeightConstraint = make.height.equalTo(0).constraint
//        }
    }
    
    func setData(text1: String?, text2: String?, text3: String?, imageName: String?) {
        label1.text = "全款\n预定"//text1
        label2.text = text2
        label3.text = text3

//        if let name = imageName, let image = UIImage(named: name) {
//            self.image.image = image
//        } else {
//            self.image.image = nil
//        }
//        self.image.sizeToFit()
//        let size = self.image.size
//        imageWidthConstraint?.update(offset: size.width)
//        imageHeightConstraint?.update(offset: size.height)
        
        if text1 == nil || text2 == nil {
            label1Trailing2Label2Constraint?.update(offset: 0)
        } else {
            label1Trailing2Label2Constraint?.update(offset: -8)
        }
        
        if (text1 == nil && text2 == nil) || text3 == nil {
            label2Trailing2Label3Constraint?.update(offset: 0)
        } else {
            label2Trailing2Label3Constraint?.update(offset: -8)
        }
        
//        if size.width <= 0 {
//            label3Trailing2ImageConstraint?.update(offset: 0)
//        } else {
//            label3Trailing2ImageConstraint?.update(offset: -8)
//        }
        
        layoutIfNeeded()
    }
    
}
