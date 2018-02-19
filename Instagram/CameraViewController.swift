//
//  CameraViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import Fusuma

class CameraViewController: UIViewController, FusumaDelegate {
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        print("Image selected")
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Multiple images selected")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Fusuma()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Fusuma() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.availableModes = [.library, .camera, .video] // The default value is [.library, .camera].
        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        
        
        self.present(fusuma, animated: true, completion: nil)
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
