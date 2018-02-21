//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton! {
        didSet {
            logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        }
    }
    
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
    
    var currentUserID : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if (Auth.auth().currentUser?.uid) != nil {
            currentUserID = (Auth.auth().currentUser?.uid)!
        }
        
        observePosts()
        observeCurrentUserInfo()
        
        
    }
    
    func observeCurrentUserInfo() {
        ref.child("users").child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
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
        
        ref.child("users").child(currentUserID).child("posts").observe(.childAdded) { (snapshot) in
            
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
    
    @objc func logOutButtonTapped() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            FBSDKLoginManager().logOut()
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension ProfileViewController : UICollectionViewDataSource {
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

extension ProfileViewController : UICollectionViewDelegate {
    
}

