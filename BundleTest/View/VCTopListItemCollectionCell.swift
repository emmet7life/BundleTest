//
//  VCTopListItemCollectionCell.swift
//  BundleTest
//
//  Created by jianli chen on 2019/6/25.
//  Copyright © 2019 jianli chen. All rights reserved.
//

import UIKit

class VCTopListItemCollectionCell: UICollectionViewCell {
    
    static let identifier = "VCTopListItemCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indexImageView: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.layer.borderColor = UIColor.gray.cgColor
//        contentView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
    }
    
    func updateData(with data: Int) {
        if data < 3 {
            indexImageView.image = UIImage(named: "ic_top_list_item_\(data + 1)")
            indexLabel.text = nil
            indexLabel.isHidden = true
        } else {
            indexImageView.image = UIImage(named: "ic_top_list_item_circel")
            indexLabel.text = String(data + 1)
            indexLabel.isHidden = false
        }
    }
    
}
