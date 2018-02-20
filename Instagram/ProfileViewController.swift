//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func addUser(_ sender: Any) {
    }
    
    @IBAction func refresh(_ sender: Any) {
    }
    
    @IBOutlet weak var userPic: UIButton!
    
    @IBOutlet weak var userPosts: UILabel!
    
    @IBOutlet weak var userFollowers: UILabel!
    
    @IBOutlet weak var userFollowing: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userDescription: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
