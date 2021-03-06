//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        }
    }
    
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var logOutChecker : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = Database.database().reference()

        if logOutChecker == true {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func signUpUser() {
        guard let userName = userNameTextField.text,
        let email = emailTextField.text,
        let password = password1TextField.text,
        let confirmPassword = password2TextField.text else {return}
        
        if !email.contains("@") {
            showAlert(withTitle: "Invalid Email Format", message: "Please input valid Email")
        } else if password.count < 5 {
            showAlert(withTitle: "Invalid Password", message: "Password must contain at least 5 characters")
        } else if password != confirmPassword {
            showAlert(withTitle: "Password Do Not Match", message: "Password Must Contain the Same Characters")
        } else if userName.count < 7 {
            showAlert(withTitle: "Username must be minimum 7 Characters", message: "Please provide a new Username")
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                }
            
                if let validUser = user {
                    
                    if let image = self.profileImageView.image {
                        self.uploadToStorage(image)
                    }
                    
                    let userPost: [String:Any] = ["email" : email, "username" : userName]
                    
                    self.ref.child("users").child(validUser.uid).setValue(userPost)
                    
                    self.logOutChecker = true
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    guard let navVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
                    
                    self.present(navVC, animated: true, completion: nil)
                    print("Sign Up Successful")
                }
            })
            
        }
    }
    
    func uploadToStorage(_ image: UIImage) {
        
        //Create Storage reference (location)
        let storageRef = Storage.storage().reference()
        
        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        // metadata contains details on the file type
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        storageRef.child(uid).child("profilepic").putData(imageData, metadata: metaData) { (meta, error) in
            
            //Error Handling
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            //Handle Successful case with metadata returned
            //MetaData contains details on the file uploaded on storage
            // We are checking whether a download URL exists
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                
                self.ref.child("users").child(uid).child("profilePicURL").setValue(downloadURL)
                
            }
        }
    }
    
    
}

extension SignUpViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
    }
      
        dismiss(animated: true, completion: nil)
        
        
    }

}


