//
//  ProfileViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {

    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func loadUserData() {
        let currentId = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child("profile").child(currentId!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dict = snapshot.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let email = dict["email"] as? String,
                    let profileURL = dict["photoURL"] as? String,
                    let url = URL(string: profileURL) {
                    
                    ImageService.getImage(withURL: url) { (image) in
                        self.profileImage.image = image
                    }
                    self.emailLabel.text = email
                    self.nameLabel.text = name
                    self.titleName.text = name
                        
                } else {
                    print("error occurred")
                }
        }
        
        let floatRef = Database.database().reference().child("floats")
        floatRef.observe(.value) { (snapshot) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
            var tempPosts: Int = 0
            var tempLikes: Int = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author =  dict["author"] as? [String: Any],
                    let uid = author["uid"] as? String,
                    let likes = dict["likes"] as? Int{
                    if uid == currentId! {
                        tempPosts += 1
                        tempLikes = likes
                    }
                }
            }
            self.postsLabel.text = String(tempPosts)
            self.likesLabel.text = String(tempLikes)
    }
    }
    
    @IBAction func changePassBtnPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailLabel.text!) { error in
            if error == nil{
                self.presentErrorPopUp(message: "An email has been sent to reset your password, once you change it log back in.", title: "Change Password")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                    try! Auth.auth().signOut()
                })
            } else {
                self.presentErrorPopUp(message: (error?.localizedDescription)!, title: "Error: Somethig went wrong")
            }
        }
    }
    
    func presentErrorPopUp(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
