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
    private var roundButton = UIButton()
    
    var hasInitallyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        activityIndicator = UIActivityIndicatorView(style:
            UIActivityIndicatorView.Style.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
        
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor(red: 255/255, green: 72/255, blue: 54/255, alpha:1)
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(self.observeFloats), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFloats()
        createFloatingButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
            }
        }
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
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
            
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    @objc func buttonClicked() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFloat") as? UINavigationController
        self.present(vc!, animated: true, completion: nil)
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
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = UIColor(red: 255/255, green: 72/255, blue: 54/255, alpha:1)
        roundButton.setTitle("FLOAT YOUR IDEA", for: .normal)
        roundButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        roundButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        DispatchQueue.main.async {
            self.roundButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
            self.roundButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
            self.roundButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
            self.roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        }
            self.roundButton.layer.cornerRadius = 10
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 3.0
            self.roundButton.layer.shadowOpacity = 0.5
        self.navigationController?.view.addSubview(self.roundButton)
        
    }
}
