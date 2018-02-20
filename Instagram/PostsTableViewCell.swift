//
//  PostsTableViewCell.swift
//  Instagram
//
//  Created by Philip Teow on 20/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit

protocol PostsTableViewCellDelegate {
    func goToCommentViewController(at : IndexPath)
}

class PostsTableViewCell: UITableViewCell {
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
    @IBOutlet weak var commentImageView: UIImageView! {
        didSet {
            commentImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            commentImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var usernameLabel2: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var delegate : PostsTableViewCellDelegate?
    var atIndexPath : IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func commentImageViewTapped (){

        delegate?.goToCommentViewController(at: atIndexPath)
        
        
    }
    


    
}
