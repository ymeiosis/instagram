//
//  PostPhotoViewController.swift
//  Instagram
//
//  Created by Ying Mei Lum on 21/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostPhotoViewController: UIViewController {
    
    var image : UIImage = UIImage(named: "") ?? UIImage()
    var ref : DatabaseReference!
    
    @IBAction func backBtn(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let navVc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
        
        self.present(navVc, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtn(_ sender: Any) {
    uploadToPost()
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        ref = Database.database().reference()
        
     }

    func uploadToStorage(_ image: UIImage, _ imagePostUID: String) {

        //Create Storage reference (location)
        let storageRef = Storage.storage().reference()

        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}

        // metadata contains details on the file type
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        guard let uid = Auth.auth().currentUser?.uid else {return}

        storageRef.child(uid).child(imagePostUID).putData(imageData, metadata: metaData) { (meta, error) in

            //Error Handling
            if let validError = error {
                print(validError.localizedDescription)
            }

            //Handle Successful case with metadata returned
            //MetaData contains details on the file uploaded on storage
            // We are checking whether a download URL exists
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("posts").child(imagePostUID).child("postedPicUrl").setValue(downloadURL)
                

            }
        }
    }

    func uploadToPost() {
        guard let caption = captionTextField.text else {return}
        guard let email = Auth.auth().currentUser?.uid else {return}
        let timeStamp = Date().timeIntervalSince1970
        let ref = self.ref.child("posts").childByAutoId()

        //upload image to storage
        if let image = self.imageView.image {
            self.uploadToStorage(image, ref.key)
        }
        let userPost: [String:Any] = ["posterID": email, "caption" : caption, "timeStamp" : timeStamp]
        
        ref.setValue(userPost)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let navVc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
        
        self.present(navVc, animated: true, completion: nil)
        
        print("sign up method successful")

    }

   

}
