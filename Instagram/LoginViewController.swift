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
    
  
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton! {
        didSet {
            facebookLoginButton.delegate = self
            
            //facebookLoginButton.addTarget(self, action: #selector(facebookShowEmailAddress), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
  
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
                
                guard let navVc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
                
                self.present(navVc, animated: true, completion: nil)
            }
        
        }
        
    }
    
  
    // Facebook Authentication Code
    @objc func facebookShowEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}

        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user", error ?? "")
                return
            }
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email, picture"])
            graphRequest?.start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("error")
                    
                }
                // Getting details based on FB Credentials
                if let validUser = user {
                    if let validResult = result as? [String:Any],
                        let name = validResult["name"] as? String,
                        let email = validResult["email"] as? String {
                    
                // Create User ID in Database
                        if let picture = validResult["picture"] as? [String:Any],
                        let data = picture["data"] as? [String:Any],
                            let url = data["url"] as? String {
                            
                            let fbUser : [String:Any] = ["email" : email, "username" : name, "profilePicURL" : url]
                            
                            self.ref.child("users").child(validUser.uid).setValue(fbUser)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            
                            guard let navVc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
                            
                            self.present(navVc, animated: true, completion: nil)
                        
                            print("Successfully Login")
                            
                        }
                    }
                    
                
                print(result ?? "")
                
            }
                
        }

          
            )}
    
        }

}

// Facebook Login Delegates - To check whether the user has logged in
extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            
            print(error)
            return
        }
        
        facebookShowEmailAddress()
        
    
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error Signing out")
        }
     
    }
}
