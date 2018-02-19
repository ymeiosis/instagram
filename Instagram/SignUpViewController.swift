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

class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

     
    }
    
    func signUpUser() {
        guard let email = emailTextField.text,
        let password = password1TextField.text,
        let confirmPassword = password2TextField.text else {return}
        
        if !email.contains("@") {
            showAlert(withTitle: "Invalid Email Format", message: "Please input valid Email")
        } else if password.count < 5 {
            showAlert(withTitle: "Invalid Password", message: "Password must contain at least 5 characters")
        } else if password != confirmPassword {
            showAlert(withTitle: "Password Do Not Match", message: "Password Must Contain the Same Characters")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                }
                
                if let validUser = user {
                    
                    let userPost: [String:Any] = ["email" : email]
                    
                    self.ref.child("users").child(validUser.uid).setValue(userPost)
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UINavigationController else {return}
                    
                    self.present(navVC, animated: true, completion: nil)
                    print("Sign Up Successful")
                }
            })
            
        }
    }


}
