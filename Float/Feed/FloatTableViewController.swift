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
        //setUpButton()
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
        refreshControl?.backgroundColor = UIColor(red: 255/255, green: 96/255, blue: 0/255, alpha:1)
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0{
            taps = taps + 1
            if taps % 2 == 0{
                self.tableView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"addButton"), for: .normal)
        // Make sure to create a function and replace DOTHISONTAP with your own function:
        roundButton.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 15),
                    keyWindow.topAnchor.constraint(equalTo: self.roundButton.topAnchor, constant: -95),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 50),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 50)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 37.5
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            // Add a pulsing animation to draw attention to button:
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
}
