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
        }
    }
    @IBOutlet weak var searchViewController: UISearchBar!
    
    var filtered : [String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var ref : DatabaseReference!
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        searchController.delegate = self
        searchController.searchBar.delegate = self
       // searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        observeUsers()
    
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
    
  

}

extension SearchViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        
        
        return cell
        
    }
}
