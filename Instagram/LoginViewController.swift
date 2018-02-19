//
//  LoginViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!{
        didSet {
            signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Sign In Using Own Database
    @objc func signInTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            
            }
            if let validUser = user {
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let navVc = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else {return}
                
                self.present(navVc, animated: true, completion: nil)
            }
        
        }
        
    }


}
