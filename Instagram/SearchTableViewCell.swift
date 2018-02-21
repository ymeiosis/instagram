//
//  SearchTableViewCell.swift
//  Instagram
//
//  Created by Ban Er Win on 21/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameTextLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var followerTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
