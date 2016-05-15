//
//  CustomTableViewCell.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/24/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//


import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

