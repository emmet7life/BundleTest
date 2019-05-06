//
//  VCFeedItemCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/4/22.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCFeedItemCell: UICollectionViewCell {
    
    static let identifier = "VCFeedItemCell_identifier"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UIButton!
    @IBOutlet weak var selectBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectBackgroundView.layer.borderColor = UIColor.colorWithHexRGBA(0x66D5FF).cgColor
        selectBackgroundView.layer.borderWidth = 2.0
        selectBackgroundView.layer.masksToBounds = true
        selectBackgroundView.layer.cornerRadius = 8.0
    }
    
}
