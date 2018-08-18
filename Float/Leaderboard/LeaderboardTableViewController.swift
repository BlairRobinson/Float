//
//  LeaderboardTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 08/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewController: UITableViewController {
    
    var floats = [Float]()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
        observeFloats()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let leaderboard = modelController.get_leaderboard()
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
    
        if(indexPath.row % 2 == 1) {
            cell.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.8)
        }
        
        let float = floats[indexPath.row]
        cell.float = float
        cell.rank.text = String(indexPath.row + 1) + "."
        
        return cell
    }
    
    func observeFloats() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let floatRef = Database.database().reference().child("floats")
        floatRef.observe(.value) { (snapshot) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
            var tempFloat = [Float]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author =  dict["author"] as? [String: Any],
                    let uid = author["uid"] as? String,
                    let name = author["name"] as? String,
                    let email = author["email"] as? String,
                    let profileURL = author["photoURL"] as? String,
                    let url = URL(string: profileURL),
                    let desc = dict["floatDescription"] as? String,
                    let time = dict["timestamp"] as? Double,
                    let peopleWholikes = dict["peopleWholikes"] as? [String],
                    let comments = dict["comments"] as? Int,
                    let likes = dict["likes"] as? Int{
                    
                    let userProfile = User(uid: uid, email: email, profileURL: url, fullName: name)
                    let float = Float(id: childSnapshot.key, float_idea: desc, user: userProfile, timestamp: time, peopleWholikes: peopleWholikes, comments: comments, likes: likes)
                    tempFloat.insert(float, at: 0)
                }
            }
            tempFloat = tempFloat.sorted(){$0.likes > $1.likes}
            self.floats = tempFloat
            self.tableView.reloadData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 1 {
            // offset = 1
            self.navigationController?.navigationBar.topItem?.title = "Leaderboard"
        } else {
            self.navigationController?.navigationBar.topItem?.title = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ViewFloatViewController,
            let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                destinationVC.float = floats[indexPath.row]
            }
        }
    }
    
}
