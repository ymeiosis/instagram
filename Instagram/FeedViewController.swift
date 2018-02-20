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
            tableView.rowHeight = 580
            tableView.separatorStyle = .none
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
        //guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedTableViewCell else {return UITableViewCell()}
        
        guard let cell = Bundle.main.loadNibNamed("PostsTableViewCell", owner: nil, options: nil)?.first as? PostsTableViewCell else {return UITableViewCell()}
        
        cell.selectionStyle = .none
        
        let currentPost = posts[indexPath.row]
        
        var posterUsername = "No posterUsername"
        var posterProfilePicUrl = "No profilePicUrl"
        ref.child("users").child(currentPost.posterID).child("username").observeSingleEvent(of: .value) { (snapshot) in
            posterUsername = snapshot.value as? String ?? "No username in snapshot"
            
            cell.usernameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.usernameLabel2.font = UIFont.boldSystemFont(ofSize: 17.0)

            cell.usernameLabel.text = posterUsername
            cell.usernameLabel2.text = posterUsername
            
            print(posterUsername)
        }
        
        ref.child("users").child(currentPost.posterID).child("profilePicUrl").observeSingleEvent(of: .value) { (snapshot) in
            posterProfilePicUrl = snapshot.value as? String ?? "No profilepic in snapshot"
            
            if let imageViewForCell = cell.profilePicImageView {
                self.getImage(posterProfilePicUrl, imageViewForCell)
            }
            
            
            self.getImage(currentPost.postedPicUrl, cell.postedImageView)
            
        }
        
        
        cell.captionLabel.text = currentPost.caption
        
        cell.numOfLikesLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        cell.numOfLikesLabel.text = String(currentPost.likes.count) + " likes"
        
        cell.atIndexPath = indexPath
        
        cell.delegate = self
        
        return cell
    }
}

extension FeedViewController : PostsTableViewCellDelegate {
    func goToCommentViewController(at : IndexPath) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController else {return}
        
        let selectedPost = posts[at.row]
        
        vc.selectedPost = selectedPost
        
        navigationController?.pushViewController(vc, animated: true)
        
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
