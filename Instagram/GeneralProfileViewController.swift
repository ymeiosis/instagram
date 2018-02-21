//
//  GeneralProfileViewController.swift
//  Instagram
//
//  Created by Philip Teow on 21/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GeneralProfileViewController: UIViewController {
    @IBOutlet weak var profilePicImageView: UIImageView! {
        didSet {
            profilePicImageView.layer.borderWidth = 1.0
            profilePicImageView.layer.masksToBounds = false
            profilePicImageView.layer.borderColor = UIColor.white.cgColor
            profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
            profilePicImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var userPosts: UILabel!
    
    @IBOutlet weak var userFollowers: UILabel!
    
    @IBOutlet weak var userFollowing: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    
    
    
    
    
    var posts : [Post] = []
    var ref : DatabaseReference!
    
    var selectedUser : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        observePosts()
        observeSelectedUserInfo()
    }
    
    func observeSelectedUserInfo() {
        ref.child("users").child(selectedUser.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String : Any] else {return}
            
            DispatchQueue.main.async {
                let picUrl = userDict["profilePicUrl"] as? String ?? "no url"
                let username = userDict["username"] as? String ?? "no username"
                let numOfFollowers = userDict["followers"] as? [String : Bool] ?? [:]
                let numOfFollowing = userDict["following"] as? [String : Bool] ?? [:]
                
                self.userName.text = username
                self.getImage(picUrl, self.profilePicImageView)
                self.userFollowers.text = String(numOfFollowers.count)
                self.userFollowing.text = String(numOfFollowing.count)
                self.userPosts.text = String(self.posts.count)
            }
        }
    }
    
    func observePosts() {
        ref.child("users").child(selectedUser.uid).child("posts").observe(.childAdded) { (snapshot) in
            
            self.ref.child("posts").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let postDict = snapshot.value as? [String : Any] else {return}
                let aPost = Post(postID: snapshot.key, dict: postDict)
                
                DispatchQueue.main.async {
                    self.posts.append(aPost)
                    let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            })
            
        }
        
    }

    

}

extension GeneralProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        
        let currentPost = posts[indexPath.row]
        
        getImage(currentPost.postedPicUrl, cell.postImageView)
        
        return cell
    }
}

extension GeneralProfileViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "GeneralFeedViewController") as? GeneralFeedViewController else {return}
        
        let selectedPost = posts[indexPath.row]
        
        vc.selectedPost = selectedPost
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


