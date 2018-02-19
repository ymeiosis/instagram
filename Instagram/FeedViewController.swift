//
//  FeedViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    
    var posts : [Post] = []
    var ref : DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        observePost()
    }
    
    
    func observePost() {
        ref.child("posts").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            
            guard let postDict = snapshot.value as? [String : Any] else {return}
            let aPost = Post(postID: snapshot.key, dict: postDict)
            
            DispatchQueue.main.async {
                self.posts.append(aPost)
                let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            
        
        }
    }
    
    
    

    


}
extension FeedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedTableViewCell else {return UITableViewCell()}
        
        let currentPost = posts[indexPath.row]
        
        var posterUsername = "No posterUsername"
        var posterProfilePicUrl = "No profilePicUrl"
        ref.child("user").child(currentPost.posterID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.key == "username" {
                posterUsername = snapshot.value as? String ?? "No username in snapshot"
            } else if snapshot.key == "profilePicUrl" {
                posterProfilePicUrl = snapshot.value as? String ?? "No profilepic in snapshot"
            }
        }
        
        if let imageViewForCell = cell.profilePicImageView {
            getImage(posterProfilePicUrl, imageViewForCell)
        }
        
        cell.usernameLabel.text = posterUsername
        
        getImage(currentPost.postedPicUrl, cell.postedImageView)
        
        cell.numOfLikesLabel.text = String(currentPost.likes.count)
        
        
        return cell
    }
}

extension UIViewController {
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let profileImage = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = profileImage
                }
            }
        }
        task.resume()
    }

}
