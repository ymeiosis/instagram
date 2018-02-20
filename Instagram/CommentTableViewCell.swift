//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderWidth = 1.0
            userImageView.layer.masksToBounds = false
            userImageView.layer.borderColor = UIColor.white.cgColor
            userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
