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
        
//     uploadToStorage(image)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPhotoViewController") as? PostPhotoViewController else {return}
        vc.image = image
        self.present(vc,animated: true, completion: nil)
        
    
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Multiple images selected")
        
        //     uploadToStorage(image)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPhotoViewController") as? PostPhotoViewController else {return}
        vc.image = images[0]
        self.present(vc,animated: true, completion: nil)
        
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
    



}
