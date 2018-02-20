//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView! {
        didSet {
            profilePicImageView.layer.borderWidth = 1.0
            profilePicImageView.layer.masksToBounds = false
            profilePicImageView.layer.borderColor = UIColor.white.cgColor
            profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
            profilePicImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var usernameLabel2: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
