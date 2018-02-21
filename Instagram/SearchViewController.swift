//
//  SearchViewController.swift
//  Instagram
//
//  Created by Philip Teow on 19/02/2018.
//  Copyright © 2018 Ying Mei Lum. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate{
 
//func updateSearchResults(for searchController: UISearchController) {
        
   // }
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        //            tableView.delegate = self
            tableView.rowHeight = 100
        }
    }
    
    
    @IBOutlet weak var searchViewController: UISearchBar!
    
    var filtered : [String] = []
    var searchActive : Bool = false
    let searchController = UISearchController()
    var ref : DatabaseReference!
    var users : [User] = []
    var currentUsers : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        //searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
       searchController.hidesNavigationBarDuringPresentation = false
        
        observeUsers()
        currentUsers = users
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tableView.reloadData()
    }
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentUsers = users
            tableView.reloadData()
            return
        }
        currentUsers = users.filter({ (User) -> Bool in
            User.username.contains(searchText)
        })
        tableView.reloadData()
        
    }

    
    func observeUsers() {
        ref.child("users").observe(.value) { (snapshot) in
            print("testing")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
        ref.child("users").queryOrdered(byChild: "username").observe(.childAdded, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}
            
            let contact = User(uid: snapshot.key, dict: userDict)
            
            DispatchQueue.main.async {
                self.users.append(contact)
                let indexPath = IndexPath(row: self.users.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            print(snapshot.key)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func renderImage(_ urlString: String, cellImageView: UIImageView) {
        
        guard let url = URL.init(string: urlString) else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    cellImageView.image = image
                }
            }
        }
        task.resume()
    }
  

}

extension SearchViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        
        let url = users[indexPath.row].url
        if let a = cell.profileImageView {
            renderImage(url, cellImageView: a)
        }
        
        cell.usernameTextLabel.text = users[indexPath.row].username
        
        return cell
        
    }
    
    
}

//extension SearchViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        return UITableViewCell()
//    }
//}

