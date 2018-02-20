//
//  PostsTableViewCell.swift
//  Instagram
//
//  Created by Philip Teow on 20/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
            
            profilePicImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            profilePicImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var usernameLabel: UILabel! {
        didSet {
            usernameLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            usernameLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var postedImageView: UIImageView! {
        didSet {
            postedImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(heartImageViewTapped))
            tap.numberOfTapsRequired = 2
            postedImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var heartImageView: UIImageView! {
        didSet {
            heartImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(heartImageViewTapped))
            heartImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var commentImageView: UIImageView! {
        didSet {
            commentImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            commentImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var usernameLabel2: UILabel! {
        didSet {
            usernameLabel2.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            usernameLabel2.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var captionLabel: UILabel! {
        didSet {
            captionLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            captionLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var numOfLikesLabel: UILabel! {
        didSet {
            numOfLikesLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            numOfLikesLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var commentLabel: UILabel! {
        didSet {
            commentLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped))
            commentLabel.addGestureRecognizer(tap)
        }
    }
    
    
    var delegate : PostsTableViewCellDelegate?
    var atIndexPath : IndexPath = IndexPath()
    var posts : [Post] = []
    var ref : DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ref = Database.database().reference()
        DispatchQueue.main.async {
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            
            self.ref.child("posts").child(self.posts[self.atIndexPath.row].postID).child("likes").observeSingleEvent(of: .value) { (snapshot) in
                if let likers = snapshot.value as? [String : Bool] {
                    for each in likers {
                        if each.key == currentUserID {
                            self.heartImageView.image = UIImage(named: "redHeart")
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    @objc func commentImageViewTapped() {
        delegate?.goToCommentViewController(at: atIndexPath)
    }
    
    @objc func heartImageViewTapped() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        ref.child("posts").child(posts[atIndexPath.row].postID).child("likes").observeSingleEvent(of: .value) { (snapshot) in
            if let likers = snapshot.value as? [String : Bool] {
                for each in likers {
                    if each.key == currentUserID {
                        return
                    }
                }
                
            }
        }
        
        ref.child("posts").child(posts[atIndexPath.row].postID).child("likes").updateChildValues([currentUserID : true])
        heartImageView.image = UIImage(named: "redHeart")

        
        
    }


    
}
