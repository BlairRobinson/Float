//
//  NewMessageTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 28/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as! UserTableViewCell

        let user = users[indexPath.row]
        cell.user = user
        return cell
    }

    @IBAction func backBtnPressed(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").child("profile").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject],
            let email = dict["email"] as? String,
            let profileURL = dict["photoURL"] as? String,
            let url = URL(string: profileURL),
            let name = dict["name"] as? String{
                let user = User(uid: snapshot.key, email: email, profileURL: url, fullName: name)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
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
