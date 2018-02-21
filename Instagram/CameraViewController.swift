//
//  CameraViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import Fusuma
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CameraViewController: UIViewController, FusumaDelegate {
    var ref: DatabaseReference!
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
       print("One image selected")
        uploadToStorage(image)
        
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Multiple images selected")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // Return an image and the detailed information.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Fusuma()
        ref = Database.database().reference()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Fusuma() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.availableModes = [.library, .camera] // The default value is [.library, .camera].
        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        fusumaCameraRollTitle = "Camera Roll"
        fusumaCameraTitle = "Camera" // Camera Title
        
        
//        self.present(fusuma, animated: true, completion: nil)
        self.parent?.present(fusuma, animated: true, completion: nil)
    }

    func uploadToStorage(_ image: UIImage) {
        
        //Create Storage reference (location)
        let storageRef = Storage.storage().reference()
        
        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {return}
        
        // metadata contains details on the file type
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        storageRef.child(uid).child("post\(arc4random())").putData(imageData, metadata: metaData) { (meta, error) in
            
            //Error Handling
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            //Handle Successful case with metadata returned
            //MetaData contains details on the file uploaded on storage
            // We are checking whether a download URL exists
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("posts").child("post\(arc4random())").child("postedPicUrl").setValue(downloadURL)
                
            }
        }
    }

}
