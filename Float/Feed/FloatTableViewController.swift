//
//  FloatTableViewCell.swift
//  Float
//
//  Created by Blair Robinson on 09/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class FloatTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    var floats = [Float]()
    var activityIndicator: UIActivityIndicatorView!
    var taps: Int = 0
    var leaderboard = [Float]()
    
    var hasInitallyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
        
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor(red: 255/255, green: 29/255, blue: 0/255, alpha:1)
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(self.observeFloats), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeFloats()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "floatCell", for: indexPath) as! FloatTableViewCell
        
        let float = floats[indexPath.row]
        cell.float = float
        cell.ranked = (leaderboard.index{$0 === float}! + 1)

        return cell
    }
    
    @objc func observeFloats() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if (refreshControl?.isRefreshing)! {
            hasInitallyLoaded = false
        }
        
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
                    let likes = dict["likes"] as? Int,
                    let category = dict["category"] as? String,
                    let title = dict["title"] as? String{
                
                    let userProfile = User(uid: uid, email: email, profileURL: url, fullName: name)
                    let float = Float(id: childSnapshot.key, title: title, float_idea: desc, user: userProfile, timestamp: time,  peopleWholikes: peopleWholikes, comments: comments, likes: likes, category: category)
                    tempFloat.insert(float, at: 0)
                    }
            }
            self.floats = tempFloat
            self.leaderboard = tempFloat.sorted(){$0.likes > $1.likes}
            
            if !self.hasInitallyLoaded {
                self.tableView.reloadData()
                self.hasInitallyLoaded = true
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 30 {
           // offset = 1
            self.navigationController?.navigationBar.topItem?.title = "Floats"
        } else {
            self.navigationController?.navigationBar.topItem?.title = nil
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0{
            taps = taps + 1
            if taps % 2 == 0{
                self.tableView.setContentOffset(.zero, animated: true)
            }
        }
    }
}
